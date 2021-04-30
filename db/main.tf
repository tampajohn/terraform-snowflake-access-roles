terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.24.0"
    }
  }
}

locals {
  databases = flatten([
    for i, db in var.database_structure : {
      index : i
      name : db.name
      comment : db.comment
    }
  ])

  schemas = flatten([
    for i, db in var.database_structure : [
      for schema_key, schema in db.schemas : {
        name : schema.name
        database : db.name
        comment : schema.comment
        is_managed : schema.is_managed
      }
    ]
  ])
}
# Generates a Database, if a conflict exists:
# terraform import 'snowflake_database.database["YOUR_DATABASE"]' YOUR_DATABASE
resource "snowflake_database" "database" {
  for_each = {
    for database in local.databases : database.name => database
  }
  name    = each.key
  comment = each.value.comment
}

# Generates a Schema for each schema defined in var.database_structure.
resource "snowflake_schema" "schema" {
  for_each = {
    for schema in local.schemas : "${schema.database}.${schema.name}" => schema
  }
  depends_on = [snowflake_database.database]

  name       = each.value.name
  database   = each.value.database
  comment    = each.value.comment
  is_managed = each.value.is_managed
}

variable "database_structure" {
  type = list(object({
    name    = string
    comment = string
    schemas = list(object({
      name       = string
      comment    = string
      is_managed = bool
    }))
  }))
}
