resource "databricks_mws_permission_assignment" "add_admin_group" {
  workspace_id = var.workspace_id
  principal_id = var.workspace_admin_group_id
  permissions  = ["ADMIN"]
}

resource "databricks_mws_permission_assignment" "add_user_group" {
  workspace_id = var.workspace_id
  principal_id = var.workspace_user_group_id
  permissions  = ["USER"]
}

