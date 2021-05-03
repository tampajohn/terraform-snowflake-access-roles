terraform {
  extra_arguments "common_vars" {
    commands = ["apply", "import", "plan", "destroy"]

    arguments = [
      "-var-file=../config/provider.tfvars",
      "-var-file=../config/rbac.tfvars",
      "-var-file=../config/structure.tfvars"
    ]
  }
}