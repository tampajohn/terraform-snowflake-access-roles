
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
    "SELECT" = ["R", "RW", "DBO"]
  }
  materialized_view = {
    "OWNERSHIP" = ["DBO"]
    "SELECT" = ["R", "RW", "DBO"]
  }
}