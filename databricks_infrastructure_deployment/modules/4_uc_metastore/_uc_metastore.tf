resource "databricks_metastore" "this" {
  name          = "metastore"
  owner         = var.account_admin_group_name
  region        = "ap-southeast-2"
  force_destroy = true
}


