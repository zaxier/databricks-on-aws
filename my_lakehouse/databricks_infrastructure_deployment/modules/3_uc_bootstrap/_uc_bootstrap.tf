// create users and groups at account level (not workspace user/group)
resource "databricks_user" "unity_users" {
  for_each                 = toset(concat(var.workspace_users, var.workspace_admins, var.account_admins))
  user_name                = each.key
  force                    = true
  disable_as_user_deletion = true
}


resource "databricks_group" "account_admin_group" {
  display_name = var.account_admin_group_name
}

resource "databricks_group" "workspace_admin_group" {
  display_name = var.workspace_admin_group_name
}

resource "databricks_group" "workspace_user_group" {
  display_name = var.workspace_user_group_name
}

resource "databricks_group_member" "admin_group_member" {
  for_each  = toset(var.account_admins)
  group_id  = databricks_group.account_admin_group.id
  member_id = databricks_user.unity_users[each.value].id
}

resource "databricks_group_member" "workspace_user_group_member" {
  for_each  = toset(var.workspace_users)
  group_id  = databricks_group.workspace_user_group.id
  member_id = databricks_user.unity_users[each.value].id
}

resource "databricks_group_member" "workspace_admin_group_member" {
  for_each  = toset(var.workspace_admins)
  group_id  = databricks_group.workspace_admin_group.id
  member_id = databricks_user.unity_users[each.value].id
}

resource "databricks_group_member" "workspace_admin_group_member_sp" {
  group_id  = databricks_group.workspace_admin_group.id
  member_id = data.databricks_service_principal.terraform_sp.id
}

resource "databricks_user_role" "account_admin_role" { // this group is admin for metastore, also pre-requisite for creating metastore
  for_each = toset(var.account_admins)
  user_id  = databricks_user.unity_users[each.value].id
  role     = "account_admin"
}

resource "databricks_service_principal_role" "terraform_admin" {
  service_principal_id = data.databricks_service_principal.terraform_sp.id
  role                 = "account_admin"
}

data "databricks_service_principal" "terraform_sp" {
  application_id = "a7c65ec9-faf2-432f-8512-2a32f798fd59"
}

resource "databricks_service_principal_secret" "terraform_sp" {
  service_principal_id = data.databricks_service_principal.terraform_sp.id
}
