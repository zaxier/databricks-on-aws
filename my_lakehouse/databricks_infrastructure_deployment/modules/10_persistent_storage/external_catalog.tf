resource "databricks_storage_credential" "this" {
  name = "persistent-storage-s3-external-access-credential"
  aws_iam_role {
    role_arn = var.aws_iam_role_arn
  }
  comment = "Managed by Terraform"
  # force_destroy = true
}

resource "databricks_external_location" "this" {
  name            = "persistent-storage-s3-external-location"
  url             = "s3://${var.s3_bucket_id}/"
  credential_name = databricks_storage_credential.this.id
  comment         = "Managed by Terraform"
  force_destroy   = true
}

resource "databricks_catalog" "this" {
  name           = var.catalog_name
  storage_root   = "s3://${var.s3_bucket_id}/${var.catalog_name}-catalog/"
  isolation_mode = var.isolation_mode
  comment        = "Managed by Terraform"
  properties = {
    purpose = var.purpose
  }
  depends_on    = [databricks_external_location.this]
  force_destroy = true
}

resource "databricks_schema" "this" {
  name         = "default"
  catalog_name = databricks_catalog.this.name
  comment      = "Managed by Terraform"
  depends_on   = [databricks_catalog.this]
  properties = {
    kind = "various"
  }
  force_destroy = true
}

resource "databricks_volume" "this" {
  name             = "files"
  catalog_name     = databricks_catalog.this.name
  schema_name      = databricks_schema.this.name
  storage_location = "s3://${var.s3_bucket_id}/files/"
  volume_type      = "EXTERNAL"
  comment          = "Managed by Terraform"
  depends_on       = [databricks_catalog.this]
}
