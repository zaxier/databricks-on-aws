output "workspace_user_group_id" {
  value = databricks_group.workspace_user_group.id
}

output "workspace_admin_group_id" {
  value = databricks_group.workspace_admin_group.id

}

output "account_admin_group_id" {
  value = databricks_group.account_admin_group.id
}