locals {
  bucket_prefix = "${replace(var.catalog_name, "_", "")}-catalog-storage-"
}


module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket_prefix = local.bucket_prefix
  versioning = {
    status = "Disabled"
  }
  object_ownership = "BucketOwnerPreferred"
  # acl              = "private"
  # restrict_public_buckets = true
  tags          = var.tags
  force_destroy = var.force_destroy
  # attach_policy           = true
  # policy                  = data.databricks_aws_bucket_policy.this.json
}

# resource "aws_s3_bucket" "catalog_storage" {
#   bucket_prefix = local.bucket_prefix
#   tags          = var.tags
#   force_destroy = var.force_destroy
#   acl = "private"
#   control_object_ownership = true
# }


# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.catalog_storage.id
#   versioning_configuration {
#     status = "Disabled"
#   }
# }

# resource "aws_s3_bucket_acl" "acl" {
#   bucket = aws_s3_bucket.catalog_storage.id
#   acl    = "private"
# }

locals {
  s3_bucket_arn    = module.s3_bucket.s3_bucket_arn
  s3_bucket_id     = module.s3_bucket.s3_bucket_id
  aws_iam_role_arn = aws_iam_role.role.arn
}


resource "aws_iam_role" "role" {
  name = "${var.catalog_name}-catalog-s3-external-access-role"
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
  name        = "${var.catalog_name}-catalog-s3-external-access-policy"
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

resource "time_sleep" "wait" {
  depends_on = [
  aws_iam_role_policy_attachment.attachment]
  create_duration = "50s"
}

resource "databricks_storage_credential" "this" {
  name = "${var.catalog_name}-catalog-s3-external-access-credential-2"
  aws_iam_role {
    role_arn = local.aws_iam_role_arn
  }
  comment    = "Managed by Terraform"
  depends_on = [time_sleep.wait]
}

resource "databricks_external_location" "this" {
  name            = "${var.catalog_name}-catalog-s3-external-location"
  url             = "s3://${local.s3_bucket_id}/root/"
  credential_name = databricks_storage_credential.this.id
  comment         = "Managed by Terraform"
  force_destroy   = true
}


resource "databricks_catalog" "this" {
  name           = var.catalog_name
  storage_root   = "s3://${local.s3_bucket_id}/root/"
  isolation_mode = var.isolation_mode
  comment        = "Managed by Terraform"
  properties = {
    purpose = var.purpose
  }
  depends_on    = [databricks_external_location.this]
  force_destroy = true
}

