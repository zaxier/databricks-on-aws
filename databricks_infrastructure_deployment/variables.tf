variable "region" {
  default = "ap-southeast-2"
  type    = string
}

variable "project_name" {
  default = "mars"
  type    = string
}


variable "aws_env" {
  default = "dev"
  type    = string
}

variable "resource_tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "databricks_account_id" {
  description = "Databricks configuration"
  type        = string
}

variable "client_id" {
  description = "Databricks oauth client id"
  type        = string
}

variable "client_secret" {
  description = "Databricks oauth client secret"
  type        = string
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

variable "workspace_admins" {
  description = "List of workspace admins"
  type        = list(string)
}

variable "workspace_users" {
  description = "List of workspace users"
  type        = list(string)
}

variable "account_admins" {
  description = "List of account admins"
  type        = list(string)
}

variable "databricks_account_owner_email" {
  description = "Email address of the account owner"
  type        = string
}