terraform state rm module.uc_bootstrap.databricks_user_role.account_admin_role
terraform state rm module.uc_bootstrap.databricks_user.unity_users
terraform destroy -auto-approve

