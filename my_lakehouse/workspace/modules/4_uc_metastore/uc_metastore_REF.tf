// aws resources for UC



# data "aws_iam_policy_document" "passrole_for_uc" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
#       type        = "AWS"
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "sts:ExternalId"
#       values   = [var.databricks_account_id]
#     }
#   }
# }


# resource "aws_iam_policy" "unity_metastore" {
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Id      = "${var.prefix}-databricks-unity-metastore"
#     Statement = [
#       {
#         "Action" : [
#           "s3:GetObject",
#           "s3:GetObjectVersion",
#           "s3:PutObject",
#           "s3:PutObjectAcl",
#           "s3:DeleteObject",
#           "s3:ListBucket",
#           "s3:GetBucketLocation"
#         ],
#         "Resource" : [
#           aws_s3_bucket.metastore.arn,
#           "${aws_s3_bucket.metastore.arn}/*"
#         ],
#         "Effect" : "Allow"
#       }
#     ]
#   })
#   tags = merge(var.tags, {
#     Name = "${var.prefix}-unity-catalog IAM policy"
#   })
# }

# // Required, in case https://docs.databricks.com/data/databricks-datasets.html are needed
# resource "aws_iam_policy" "sample_data" {
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Id      = "${var.prefix}-databricks-sample-data"
#     Statement = [
#       {
#         "Action" : [
#           "s3:GetObject",
#           "s3:GetObjectVersion",
#           "s3:ListBucket",
#           "s3:GetBucketLocation"
#         ],
#         "Resource" : [
#           "arn:aws:s3:::databricks-datasets-oregon/*",
#           "arn:aws:s3:::databricks-datasets-oregon"
#         ],
#         "Effect" : "Allow"
#       }
#     ]
#   })
#   tags = merge(var.tags, {
#     Name = "${var.prefix}-unity-catalog IAM policy"
#   })
# }

# resource "aws_iam_role" "metastore_data_access" {
#   name                = "${var.prefix}-uc-access"
#   assume_role_policy  = data.aws_iam_policy_document.passrole_for_uc.json
#   managed_policy_arns = [aws_iam_policy.unity_metastore.arn, aws_iam_policy.sample_data.arn]
#   tags = merge(var.tags, {
#     Name = "${var.prefix}-unity-catalog IAM role"
#   })
# }


# resource "aws_s3_bucket" "external" {
#     bucket_prefix = "${var.prefix}-external-storage-bucket"
#     force_destroy = true
#     tags = var.tags
# }

# # S3 Bucket - Ownership Controls
# resource "aws_s3_bucket_ownership_controls" "external" {
#   bucket = aws_s3_bucket.external.id
#   rule {
#     object_ownership = "BucketOwnerEnforced"
#   }
# }

# # S3 Bucket - ACL
# resource "aws_s3_bucket_acl" "external" {
#   depends_on = [aws_s3_bucket_ownership_controls.example]
#   bucket = aws_s3_bucket.external.id
#   acl    = "private"
# }

# # S3 Bucket - Versioning
# resource "aws_s3_bucket_versioning" "external_bucket_versioning" {
#   bucket = aws_s3_bucket.external.id
#   versioning_configuration {
#     status = "Disabled"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "external" {
#   bucket             = aws_s3_bucket.external.id
#   ignore_public_acls = true
#   depends_on         = [aws_s3_bucket.external]
# }

# resource "aws_iam_policy" "external_data_access" {
#   // Terraform's "jsonencode" function converts a
#   // Terraform expression's result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Id      = "${aws_s3_bucket.external.id}-access"
#     Statement = [
#       {
#         "Action" : [
#           "s3:GetObject",
#           "s3:GetObjectVersion",
#           "s3:PutObject",
#           "s3:PutObjectAcl",
#           "s3:DeleteObject",
#           "s3:ListBucket",
#           "s3:GetBucketLocation"
#         ],
#         "Resource" : [
#           aws_s3_bucket.external.arn,
#           "${aws_s3_bucket.external.arn}/*"
#         ],
#         "Effect" : "Allow"
#       }
#     ]
#   })
#   tags = merge(var.tags, {
#     Name = "${var.prefix}-unity-catalog external access IAM policy"
#   })
# }