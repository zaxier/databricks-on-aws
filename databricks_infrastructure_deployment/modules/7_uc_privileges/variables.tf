variable "account_admin_group_name" {
  description = "The name of the group that will be used to grant account admin privileges"
  type        = string
}

variable "workspace_user_group_name" {
  description = "The name of the group that will be used to grant workspace user privileges"
  type        = string
}

variable "workspace_admin_group_name" {
  description = "The name of the group that will be used to grant workspace admin privileges"
  type        = string
}

variable "metastore_id" {
  description = "The id of the metastore to grant privileges to"
  type        = string
}