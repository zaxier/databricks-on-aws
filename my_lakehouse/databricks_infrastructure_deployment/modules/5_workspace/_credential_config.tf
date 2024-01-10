resource "databricks_mws_credentials" "this" {
  # account_id       = var.databricks_account_id
  role_arn         = var.aws_crossaccount_role_arn
  credentials_name = "${var.workspace_name}-creds"
}
