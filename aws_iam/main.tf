provider "aws" {
    region = "ap-southeast-2"
}

resource "aws_iam_group" "admin" {
    name = "admin"
    path = "/"
}

resource "aws_iam_user" "dbx_account_admin" {
    name = "dbx_account_admin"
    path = "/"
}

resource "aws_iam_group_membership" "admin" {
    name = "admin_group_membership"

    users = [
        aws_iam_user.dbx_account_admin.name,
    ]

    group = aws_iam_group.admin.name
}

resource "aws_iam_group_policy_attachment" "admin" {
    group      = aws_iam_group.admin.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "dbx_account_admin_key" {
    user = aws_iam_user.dbx_account_admin.name
}

output "dbx_account_admin_access_key_id" {
    description = "The access key ID for dbx_account_admin"
    value       = aws_iam_access_key.dbx_account_admin_key.id
}

output "dbx_account_admin_secret_access_key" {
    description = "The secret access key for dbx_account_admin. This will be encrypted in the state file."
    value       = aws_iam_access_key.dbx_account_admin_key.secret
    sensitive   = true
}