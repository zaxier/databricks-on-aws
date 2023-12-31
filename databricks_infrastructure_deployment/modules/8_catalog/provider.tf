terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.32.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

