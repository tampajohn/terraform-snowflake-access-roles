terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.24.0"
    }
  }
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

variable "access_grants" {
  type = object({
    database          = map(list(string))
    schema            = map(list(string))
    table             = map(list(string))
    view              = map(list(string))
    materialized_view = map(list(string))
    access_role_hierarchy = map(list(string))

  })
}

locals {
  access_roles = distinct(flatten([
    for object_type in var.access_grants : [
      for permission in object_type : [
        for access_role_suffix in permission : access_role_suffix
      ]
    ]
  ]))

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

  schema_roles = flatten([
    for schema in local.schemas : [
      for access_role in local.access_roles : {
        database : schema.database
        schema : schema.name
        role_type : access_role
      }
    ]
  ])

  database_grants = flatten([
    for database in local.databases : [
      for permission_key, roles in var.access_grants.database : {
        database : database.name
        privilege : permission_key
        roles : flatten([for r in roles : [for schema_name, s in var.database_structure[database.index].schemas : "_${database.name}_${s.name}_${r}"]])
      }
    ]
  ])

  schema_grants = flatten([
    for schema in local.schemas : [
      for permission_key, roles in var.access_grants.schema : {
        database : schema.database
        schema : schema.name
        privilege : permission_key
        roles : [for r in roles : "_${schema.database}_${schema.name}_${r}"]
      }
    ]
  ])

  table_grants = flatten([
    for schema in local.schemas : [
      for permission_key, roles in var.access_grants.table : {
        database : schema.database
        schema : schema.name
        privilege : permission_key
        roles : [for r in roles : "_${schema.database}_${schema.name}_${r}"]
      }
    ]
  ])

  view_grants = flatten([
    for schema in local.schemas : [
      for permission_key, roles in var.access_grants.view : {
        database : schema.database
        schema : schema.name
        privilege : permission_key
        roles : [for r in roles : "_${schema.database}_${schema.name}_${r}"]
      }
    ]
  ])

  role_grants = flatten([
    for schema in local.schemas : [
      for granter_key, grantees in var.access_grants.access_role_hierarchy : {
        from: "_${schema.database}_${schema.name}_${granter_key}"
        to: [for grantee_key in grantees : "_${schema.database}_${schema.name}_${grantee_key}"]
      }
    ]
  ])
}

# Generates a role PER database PER schema PER access_role like: _SNOWFLAKE_PUBLIC_R, _SNOWFLAKE_PUBLIC_RW, etc
resource "snowflake_role" "access_role" {
  for_each = {
    for schema_role in local.schema_roles : "_${schema_role.database}_${schema_role.schema}_${schema_role.role_type}" => schema_role
  }
  name = each.key
}

resource "snowflake_role_grants" "role_grants" {
  for_each = {
    for grant in local.role_grants : grant.from => grant.to
  }
  role_name  = each.key
  roles         = each.value
}

# Generates grants for each database defined in var.database_structure, based on values in access_grants["DATABASE"]
resource "snowflake_database_grant" "db_grant" {
  for_each = {
    for grant in local.database_grants : "_${grant.database}_${grant.privilege}" => grant
  }
  depends_on    = [snowflake_role.access_role]
  database_name = each.value.database
  privilege     = each.value.privilege
  roles         = each.value.roles
}

# Generates grants for each schema defined in var.database_structure, based on values in access_grants["SCHEMA"]
resource "snowflake_schema_grant" "schema_grant" {
  for_each = {
    for grant in local.schema_grants : "_${grant.database}_${grant.schema}_${grant.privilege}" => grant
  }

  depends_on    = [snowflake_role.access_role]
  database_name = each.value.database
  schema_name   = each.value.schema
  privilege     = each.value.privilege
  roles         = each.value.roles
}

# Generates future grants for each schema defined in var.database_structure, based on values in access_grants.table
resource "snowflake_table_grant" "table_grant" {
  for_each = {
    for grant in local.table_grants : "_${grant.database}_${grant.schema}_${grant.privilege}" => grant
  }

  depends_on    = [snowflake_role.access_role]
  database_name = each.value.database
  schema_name   = each.value.schema
  privilege     = each.value.privilege
  roles         = each.value.roles
  on_future     = true
}


# Generates future grants for each schema defined in var.database_structure, based on values in access_grants.view
resource "snowflake_view_grant" "view_grant" {
  for_each = {
    for grant in local.view_grants : "_${grant.database}_${grant.schema}_${grant.privilege}" => grant
  }

  depends_on    = [snowflake_role.access_role]
  database_name = each.value.database
  schema_name   = each.value.schema
  privilege     = each.value.privilege
  roles         = each.value.roles
  on_future     = true
}
