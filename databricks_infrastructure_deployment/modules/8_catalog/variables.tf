variable "databricks_account_id" {
  description = "Databricks account id"
  type        = string
}

variable "tags" {
  default = {}
  type    = map(string)
}

variable "force_destroy" {
  description = "Whether all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "catalog_name" {
  description = "Name of the catalog"
  type        = string
}

variable "isolation_mode" {
  description = "Isolation mode of the catalog"
  type        = string
}

variable "purpose" {
  description = "Purpose of the catalog"
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