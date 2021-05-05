database_structure = [{
  name    = "NDG"
  comment = "NASCAR Data Garage",
  schemas = [
    {
      name       = "DM"
      comment    = "Data Model Schema"
      is_managed = true
      functional_grants = {
        "R" : ["O365_SG_SNOWFLAKE_ANALYST"]
      }
    },
    {
      name       = "EUL"
      comment    = "End-User Layer"
      is_managed = true
      functional_grants = {
        "R" : ["O365_SG_SNOWFLAKE_ANALYST"]
        "RW" : ["O365_SG_SNOWFLAKE_DEVELOPER"]
        "DBO" : ["O365_SG_SNOWFLAKE_DBA"]
      }
    }
  ]
  functional_grants = {
    "DBO" : ["O365_SG_SNOWFLAKE_DBA"]
  }
}]
########################################################################################################################
#
# Grants will be created with the following nomenclature: _{DBNAME}_{SCHEMANAME}_{ACCESSTYPE} and _{DBNAME}_{ACCESSTYPE}
#     ie: _PROD_SCHEMA_R, _PROD_R
#
########################################################################################################################
access_grants = {
  database = {
    "USAGE" = ["R", "RW", "DBO"]
  },
  schema = {
    "OWNERSHIP"                = ["DBO"]
    "USAGE"                    = ["R", "RW", "DBO"]
    "CREATE TABLE"             = ["DBO"]
    "CREATE VIEW"              = ["DBO"]
    "CREATE STAGE"             = ["DBO"]
    "CREATE PIPE"              = ["DBO"]
    "CREATE STREAM"            = ["DBO"]
    "CREATE TASK"              = ["DBO"]
    "CREATE FUNCTION"          = ["DBO"]
    "CREATE PROCEDURE"         = ["DBO"]
    "CREATE EXTERNAL TABLE"    = ["DBO"]
    "CREATE MATERIALIZED VIEW" = ["DBO"]
    "CREATE PIPE"              = ["DBO"]
    "CREATE SEQUENCE"          = ["DBO"]
  }
  table = {
    "OWNERSHIP" = ["DBO"]
    "SELECT"    = ["R", "RW", "DBO"]
    "UPDATE"    = ["RW", "DBO"]
    "INSERT"    = ["RW", "DBO"]
    "DELETE"    = ["RW", "DBO"]
  }
  view = {
    "OWNERSHIP" = ["DBO"]
    "SELECT"    = ["R", "RW", "DBO"]
  }
  materialized_view = {
    "OWNERSHIP" = ["DBO"]
    "SELECT"    = ["R", "RW", "DBO"]
  }
  access_role_hierarchy = {
    "R" : ["RW"]
    "RW" : ["DBO"]
    "DBO" : [] // This will allow us to grant it to function roles specified in structure vars.
  }
}