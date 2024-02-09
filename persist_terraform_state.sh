#/bin/bash
cd my_lakehouse/databricks_infrastructure_deployment
terraform output --json > ../../workspace_details_sensitive.json
cd ../..


