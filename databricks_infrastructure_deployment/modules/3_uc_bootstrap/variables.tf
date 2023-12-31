# variable "prefix" {
#   description = "Prefix to be used for all resources"
#   type        = string
# }

variable "tags" {
  default = {}
  type    = map(string)
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID"
}

variable "workspace_users" {
  description = "List of Databricks users to be added at account-level for Unity Catalog."
  type        = list(string)
}

variable "workspace_admins" {
  description = "List of Databricks admins to be added at account-level for Unity Catalog."
  type        = list(string)
}

variable "account_admins" {
  description = "List of Admins to be added at account-level for Unity Catalog."
  type        = list(string)
}

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