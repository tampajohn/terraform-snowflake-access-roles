database_structure = [{
  name    = "NDG"
  comment = "NASCAR Data Garage",
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