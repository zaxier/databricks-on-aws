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

provider "aws" {
  region = var.region
}

// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias   = "mws_accowner"
  host    = "https://accounts.cloud.databricks.com"
  profile = "my_account_owner"
}

provider "databricks" {
  alias         = "mws_sp"
  host          = "https://accounts.cloud.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
  # profile = "my_account_admin_sp"
}

provider "databricks" {
  alias = "dev_ws"
  host  = module.dev_workspace.workspace_url
  token = module.dev_workspace.databricks_token

}