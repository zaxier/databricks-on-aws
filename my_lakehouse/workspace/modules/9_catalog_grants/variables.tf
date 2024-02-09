variable "catalog_name" {
  description = "The name of the catalog"
  type        = string
}

variable "account_admin_group_name" {
  description = "The name of the group that will be used to grant account admin privileges"
  type        = string
}

variable "workspace_admin_group_name" {
  description = "The name of the group that will be used to grant workspace admin privileges"
  type        = string
}

variable "workspace_user_group_name" {
  description = "The name of the group that will be used to grant workspace user privileges"
  type        = string
}

variable "workspace_admin_grants" {
  description = "The list of privileges to grant to the workspace admin group"
  type        = list(string)
}

variable "workspace_user_grants" {
  description = "The list of privileges to grant to the workspace user group"
  type        = list(string)
}

variable "account_admin_grants" {
  description = "The list of privileges to grant to the account admin group"
  type        = list(string)
}