data "databricks_current_user" "me" {
  depends_on = [databricks_mws_workspaces.this]
}