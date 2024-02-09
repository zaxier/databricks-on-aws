variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "persistent_storage_name" {
  description = "Name of the persistent storage"
  type        = string
}

variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
}