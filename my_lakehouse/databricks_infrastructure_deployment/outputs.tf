output "dev_ws_url" {
  value = module.dev_workspace.workspace_url
}

output "dev_ws_id" {
  value = module.dev_workspace.workspace_id
}

output "dev_ws_token" {
  value = module.dev_workspace.databricks_token
  sensitive = true
}

output "sp_secret" {
  value = module.uc_bootstrap.sp_secret
  sensitive = true
}