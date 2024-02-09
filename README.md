
### 1. Install cli tools if you need them
```sh
./install_clis.sh
```

### 2. Change directory
```sh
cd terraform/workspace
```

### 3. Create tfvars file like below and then apply
```terraform
databricks_account_id          = ""
client_id                      = ""
client_secret                  = ""
account_admin_group_name       = ""
workspace_user_group_name      = ""
workspace_admin_group_name     = ""
workspace_admins               = []
workspace_users                = []
account_admins                 = []
databricks_account_owner_email = ""
```

### 4. Apply terraform
```sh
terraform apply
```


## Dependencies
- AWS account with credentials
- Databricks account with credentials
 
TODO: create default schema in each catalog

