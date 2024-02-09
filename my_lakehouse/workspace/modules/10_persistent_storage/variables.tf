variable "aws_iam_role_arn" {
  description = "ARN of the IAM role to be used by Databricks to access the S3 bucket"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket"
  type        = string 
}

variable "isolation_mode" {
  description = "Isolation mode of the catalog"
  type        = string
  default     = "OPEN"
}

variable "purpose" {
  description = "Purpose of the catalog"
  type        = string
  default     = "persistent-storage"
}

variable "catalog_name" {
  description = "Name of the catalog"
  type        = string
}