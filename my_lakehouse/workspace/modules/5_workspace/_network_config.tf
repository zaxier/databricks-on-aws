resource "databricks_mws_networks" "this" {
  account_id         = var.databricks_account_id
  network_name       = "${var.workspace_name}-network"
  vpc_id             = var.vpc_id
  subnet_ids         = var.private_subnets
  security_group_ids = [var.default_security_group_id]
}