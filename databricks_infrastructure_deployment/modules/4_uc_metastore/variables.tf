variable "account_admin_group_name" {
  description = "Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
}

variable "workspace_user_group_name" {
  description = "Name of the user group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
}

variable "workspace_admin_group_name" {
  description = "Name of the workspace admin group"
  type        = string
}