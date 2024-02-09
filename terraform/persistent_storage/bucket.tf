module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.persistent_storage_name}-persistent-storage"
  versioning = {
    status = "Disabled"
  }
  object_ownership = "BucketOwnerPreferred"
  tags          = var.tags
}


locals {
  s3_bucket_arn    = module.s3_bucket.s3_bucket_arn
  s3_bucket_id     = module.s3_bucket.s3_bucket_id
  aws_iam_role_arn = aws_iam_role.role.arn
}


resource "aws_iam_role" "role" {
  name = "${var.persistent_storage_name}-persistent-storage-s3-external-access-role"
  assume_role_policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"
        },
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.databricks_account_id
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_policy" "policy" {
  name        = "${var.persistent_storage_name}-persistent-storage-s3-external-access-policy"
  description = "Policy for S3 Bucket Access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
        ],
        Effect = "Allow",
        Resource = [
          local.s3_bucket_arn,
          "${local.s3_bucket_arn}/*"
        ]
      },
      {
        Action   = ["sts:AssumeRole"],
        Effect   = "Allow",
        Resource = [aws_iam_role.role.arn]
      }
    ]
  })
  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
  # depends_on = [time_sleep.wait]
}

