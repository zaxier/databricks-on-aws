variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "default_security_group_id" {
  description = "Default Security Group ID"
  type        = string
}

variable "private_subnets" {
  description = "Subnet IDs"
  type        = list(string)
}


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

variable "aws_crossaccount_role_arn" {
  description = "ARN of the AWS cross-account role"
  type        = string
}

variable "workspace_name" {
  description = "Name of the workspace"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string

}

variable "metastore_id" {
  description = "ID of the metastore"
  type        = string
}