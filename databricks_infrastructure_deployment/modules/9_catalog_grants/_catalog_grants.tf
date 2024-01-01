
resource "databricks_grants" "catalog" {
  catalog = var.catalog_name

  grant {
    principal  = var.account_admin_group_name
    privileges = var.account_admin_grants
  }

  grant {
    principal  = var.workspace_admin_group_name
    privileges = var.workspace_admin_grants
  }

  grant {
    principal  = var.workspace_user_group_name
    privileges = var.workspace_user_grants
  }
}