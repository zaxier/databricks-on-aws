variable "aws_prefix" {
  description = "Prefix to be used for all resources"
  type        = string
}

variable "cidr" {
  type    = string
  default = "10.4.0.0/16"
}

variable "databricks_account_id" {
  description = "Databricks account id"
  type        = string
}

variable "tags" {
  default = {}
  type    = map(string)
}
