database_structure = [{
  name    = "JQA_PROD"
  comment = "An example production database",
  schemas = [
    {
      name       = "RAW"
      comment    = "Raw landing data for this db."
      is_managed = true
    },
    {
      name       = "ANALYTICS"
      comment    = "Analytics data for this db."
      is_managed = true
    }
  ]
}]