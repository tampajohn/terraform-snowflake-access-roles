database_structure = [{
  name    = "PROTO"
  comment = "PROTO Database",
  schemas = [
    {
      name       = "DM"
      comment    = "Data Model Schema"
      is_managed = true
    },
    {
      name       = "EUL"
      comment    = "End-User Layer"
      is_managed = true
    }
  ]
}]