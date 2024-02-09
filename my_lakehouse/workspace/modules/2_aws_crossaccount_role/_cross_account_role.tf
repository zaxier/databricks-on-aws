data "databricks_aws_crossaccount_policy" "this" {
}

resource "aws_iam_policy" "cross_account_policy" {
  name        = "${var.aws_prefix}-dbx-crossaccount-iam-policy"
  description = "Databricks cross-account policy"
  policy      = data.databricks_aws_crossaccount_policy.this.json
  tags        = var.tags

}

data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account_role" {
  name               = "${var.aws_prefix}-dbx-crossaccount-role"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = var.tags
  description        = "Grant Databricks full access to VPC resources"
}

resource "aws_iam_role_policy_attachment" "cross_account_policy_attachment" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.cross_account_policy.arn

}

resource "time_sleep" "wait" {
  depends_on = [
  aws_iam_role.cross_account_role]
  create_duration = "30s"
}