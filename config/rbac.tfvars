
access_grants = {
  database = {
    "USAGE" = ["R", "RW", "FULL"]
  },
  schema = {
    "OWNERSHIP"                = ["FULL"]
    "USAGE"                    = ["R", "RW", "FULL"]
    "CREATE TABLE"             = ["FULL"]
    "CREATE VIEW"              = ["FULL"]
    "CREATE STAGE"             = ["FULL"]
    "CREATE PIPE"              = ["FULL"]
    "CREATE STREAM"            = ["FULL"]
    "CREATE TASK"              = ["FULL"]
    "CREATE FUNCTION"          = ["FULL"]
    "CREATE PROCEDURE"         = ["FULL"]
    "CREATE EXTERNAL TABLE"    = ["FULL"]
    "CREATE MATERIALIZED VIEW" = ["FULL"]
    "CREATE PIPE"              = ["FULL"]
    "CREATE SEQUENCE"          = ["FULL"]
  }
  table = {
    "OWNERSHIP" = ["FULL"]
    "SELECT"    = ["R", "RW", "FULL"]
    "UPDATE"    = ["RW", "FULL"]
    "INSERT"    = ["RW", "FULL"]
    "DELETE"    = ["RW", "FULL"]
  }
  view = {
    "OWNERSHIP" = ["FULL"]
    "SELECT" = ["R", "RW", "FULL"]
  }
  materialized_view = {
    "OWNERSHIP" = ["FULL"]
    "SELECT" = ["R", "RW", "FULL"]
  }
  access_role_hierarchy = {
    "R": ["RW"]
    "RW": ["FULL"]
  }
}