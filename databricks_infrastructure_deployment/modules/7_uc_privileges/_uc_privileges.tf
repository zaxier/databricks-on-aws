resource "databricks_grants" "this" {
  metastore = var.metastore_id
  grant {
    principal  = var.account_admin_group_name
    privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION", "CREATE_STORAGE_CREDENTIAL"]
  }

  grant {
    principal  = var.workspace_user_group_name
    privileges = ["CREATE_SHARE", "SET_SHARE_PERMISSION", "USE_MARKETPLACE_ASSETS", "USE_CONNECTION", "USE_PROVIDER", "USE_RECIPIENT", "USE_SHARE"]
  }

  grant {
    principal  = var.workspace_admin_group_name
    privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION", "CREATE_CONNECTION", "CREATE_PROVIDER", "CREATE_RECIPIENT", "CREATE_SHARE", "CREATE_STORAGE_CREDENTIAL", "MANAGE_ALLOWLIST", "SET_SHARE_PERMISSION", "USE_MARKETPLACE_ASSETS", "USE_CONNECTION", "USE_PROVIDER", "USE_RECIPIENT", "USE_SHARE"]
  }
}