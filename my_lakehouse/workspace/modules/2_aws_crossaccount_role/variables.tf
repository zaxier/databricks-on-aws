variable "aws_prefix" {
  description = "Prefix to be used for all resources"
  type        = string
}

variable "databricks_account_id" {
  description = "Databricks account id"
  type        = string
}

variable "tags" {
  default = {}
  type    = map(string)
}
