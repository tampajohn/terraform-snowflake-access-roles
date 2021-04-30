

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "snowflake" {
  account  = var.snowflake_account
  region   = var.snowflake_region
  username = var.snowflake_user
  
  private_key_path = var.snowflake_key_path 
  role             = var.snowflake_role
}

variable "snowflake_account" {}
variable "snowflake_region" {}
variable "snowflake_user" {}
variable "snowflake_role" {}
variable "snowflake_key_path" {}
EOF
}

terraform {
  extra_arguments "common_vars" {
    commands = ["apply", "import"]

    arguments = [
      "-var-file=../config/provider.tfvars",
      "-var-file=../config/rbac.tfvars",
      "-var-file=../config/structure.tfvars"
    ]
  }
}