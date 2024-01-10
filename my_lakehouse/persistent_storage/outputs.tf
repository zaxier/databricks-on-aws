output "s3_bucket_id" {
  value = module.s3_bucket.s3_bucket_id
}

output "aws_iam_role_arn" {
  value = aws_iam_role.role.arn
}

output "persistent_storage_name" {
  value = var.persistent_storage_name
}

