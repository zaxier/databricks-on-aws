locals {
  required_tags = {
    Project     = var.project_name
    Environment = var.aws_env
  }
  tags            = merge(var.resource_tags, local.required_tags)
  aws_name_prefix = "${var.project_name}-aws-${var.aws_env}"
}

# module "aws_resources" {
#   source            = "./modules/aws"
#   prefix            = local.aws_name_prefix
#   tags              = local.tags
#   vpc_config        = var.vpc_config
#   databricks_config = var.databricks_config
# }

# module "dbx_resources" {
#   source = "./modules/dbx"
#   providers = {
#     databricks = databricks.mws_accowner
#   }
#   prefix                    = local.aws_name_prefix
#   tags                      = local.tags
#   databricks_config         = var.databricks_config
#   vpc_id                    = module.aws_resources.vpc_id
#   crossaccount_role_arn     = module.aws_resources.cross_account_role_arn
#   databricks_account_admins = ["xtarmitage@gmail.com"]
#   databricks_users          = ["abc@gmail.com"]
#   account_admin_group_name         = "admin-grp"
# }

module "aws_vpc" {
  source                = "./modules/1_aws_vpc"
  aws_prefix            = local.aws_name_prefix
  tags                  = local.tags
  databricks_account_id = var.databricks_account_id
}

module "aws_crossaccount_role" {
  source                = "./modules/2_aws_crossaccount_role"
  aws_prefix            = local.aws_name_prefix
  tags                  = local.tags
  databricks_account_id = var.databricks_account_id
  depends_on            = [module.aws_vpc]
}

module "uc_bootstrap" {
  source = "./modules/3_uc_bootstrap"
  providers = {
    databricks = databricks.mws_accowner
  }
  tags                           = local.tags
  databricks_account_id          = var.databricks_account_id
  workspace_users                = var.workspace_users
  workspace_admins               = var.workspace_admins
  account_admins                 = var.account_admins
  account_admin_group_name       = var.account_admin_group_name
  workspace_user_group_name      = var.workspace_user_group_name
  workspace_admin_group_name     = var.workspace_admin_group_name
  databricks_account_owner_email = var.databricks_account_owner_email
  depends_on                     = [module.aws_crossaccount_role]
}

module "uc_metastore" {
  source = "./modules/4_uc_metastore"
  providers = {
    databricks = databricks.mws_accowner
  }
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  depends_on                 = [module.uc_bootstrap]
}

module "dev_workspace" {
  source = "./modules/5_workspace"
  providers = {
    databricks = databricks.mws_accowner
  }
  aws_prefix                = local.aws_name_prefix
  tags                      = local.tags
  databricks_account_id     = var.databricks_account_id
  aws_crossaccount_role_arn = module.aws_crossaccount_role.aws_crossaccount_role_arn
  workspace_name            = "dev"
  vpc_id                    = module.aws_vpc.vpc_id
  default_security_group_id = module.aws_vpc.default_security_group_id
  private_subnets           = module.aws_vpc.private_subnet_ids
  region                    = var.region
  metastore_id              = module.uc_metastore.metastore_id
  depends_on                = [module.uc_metastore]
}

module "workspace_users" {
  source = "./modules/6_workspace_user_assignment"
  providers = {
    databricks = databricks.mws_accowner
  }
  workspace_id             = module.dev_workspace.workspace_id
  account_admin_group_id   = module.uc_bootstrap.account_admin_group_id
  workspace_user_group_id  = module.uc_bootstrap.workspace_user_group_id
  workspace_admin_group_id = module.uc_bootstrap.workspace_admin_group_id
  depends_on               = [module.dev_workspace]
}

module "uc_privileges" {
  source = "./modules/7_uc_privileges"
  providers = {
    databricks = databricks.dev_ws
  }
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  metastore_id               = module.uc_metastore.metastore_id
  depends_on                 = [module.dev_workspace]
}

module "dev_catalog" {
  source = "./modules/8_catalog"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name               = "_dev"
  isolation_mode             = "OPEN" # OPTIONS: ISOLATED, OPEN
  databricks_account_id      = var.databricks_account_id
  force_destroy              = true
  tags                       = local.tags
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  purpose                    = "dev"
  depends_on                 = [module.dev_workspace, module.uc_metastore, module.uc_privileges]
}


module "test_catalog" {
  source = "./modules/8_catalog"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name               = "_test"
  isolation_mode             = "OPEN" # OPTIONS: ISOLATED, OPEN
  databricks_account_id      = var.databricks_account_id
  force_destroy              = true
  tags                       = local.tags
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  purpose                    = "test"
  depends_on                 = [module.dev_workspace, module.uc_metastore, module.uc_privileges]
}

module "prod_catalog" {
  source = "./modules/8_catalog"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name               = "_prod"
  isolation_mode             = "OPEN" # OPTIONS: ISOLATED, OPEN
  databricks_account_id      = var.databricks_account_id
  force_destroy              = true
  tags                       = local.tags
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  purpose                    = "prod"
  depends_on                 = [module.dev_workspace, module.uc_metastore, module.uc_privileges]

}

module "dev_catalog_grants" {
  source = "./modules/9_catalog_grants"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name               = module.dev_catalog.catalog_name
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  workspace_admin_grants     = ["ALL_PRIVILEGES"]
  workspace_user_grants      = ["USE_CATALOG", "CREATE_FUNCTION", "CREATE_TABLE", "CREATE_VOLUME", "EXECUTE", "MODIFY", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
  account_admin_grants       = ["ALL_PRIVILEGES"]
  depends_on                 = [module.dev_catalog]
}

module "test_catalog_grants" {
  source = "./modules/9_catalog_grants"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name               = module.test_catalog.catalog_name
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  workspace_admin_grants     = ["ALL_PRIVILEGES"]
  workspace_user_grants      = ["USE_CATALOG", "CREATE_FUNCTION", "CREATE_TABLE", "CREATE_VOLUME", "EXECUTE", "MODIFY", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
  account_admin_grants       = ["ALL_PRIVILEGES"]
  depends_on                 = [module.test_catalog]
}

module "prod_catalog_grants" {
  source = "./modules/9_catalog_grants"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name               = module.prod_catalog.catalog_name
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  workspace_admin_grants     = ["ALL_PRIVILEGES"]
  workspace_user_grants      = ["USE_CATALOG", "CREATE_FUNCTION", "CREATE_TABLE", "CREATE_VOLUME", "EXECUTE", "MODIFY", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
  account_admin_grants       = ["ALL_PRIVILEGES"]
  depends_on                 = [module.prod_catalog]
}


module "persistent_storage" {
  source = "./modules/10_persistent_storage"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name = "_persist"
  aws_iam_role_arn        = "arn:aws:iam::136146594194:role/databricks-zaxier-persistent-storage-s3-external-access-role"
  s3_bucket_id            = "databricks-zaxier-persistent-storage"
  isolation_mode          = "OPEN" # OPTIONS: ISOLATED, OPEN
  purpose                 = "persistent-storage"
  depends_on              = [module.dev_workspace]
}

module "persist_catalog_grants" {
  source = "./modules/9_catalog_grants"
  providers = {
    databricks = databricks.dev_ws
  }
  catalog_name               = module.persistent_storage.catalog_name
  account_admin_group_name   = var.account_admin_group_name
  workspace_admin_group_name = var.workspace_admin_group_name
  workspace_user_group_name  = var.workspace_user_group_name
  workspace_admin_grants     = ["ALL_PRIVILEGES"]
  workspace_user_grants      = ["USE_CATALOG", "CREATE_FUNCTION", "CREATE_TABLE", "CREATE_VOLUME", "EXECUTE", "MODIFY", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
  account_admin_grants       = ["ALL_PRIVILEGES"]
  depends_on                 = [module.persistent_storage]
}

# module "pat_tokens" {
#   source = "./modules/11_pat"
#   providers = {
#     databricks = databricks.dev_ws
#   }
#   depends_on                 = [module.dev_workspace]
# }

# resource "databricks_grants" "catalog" {
#   catalog = databricks_catalog.this.name

#   grant {
#     principal  = var.account_admin_group_name
#     privileges = ["ALL_PRIVILEGES"]
#   }

#   grant {
#     principal  = var.workspace_admin_group_name
#     privileges = ["ALL_PRIVILEGES"]
#   }

#   grant {
#     principal  = var.workspace_user_group_name
#     privileges = ["USE_CATALOG", "CREATE_FUNCTION", "CREATE_TABLE", "CREATE_VOLUME", "EXECUTE", "MODIFY", "REFRESH", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "USE_SCHEMA"]
#   }
#   depends_on = [databricks_catalog.this]
# }