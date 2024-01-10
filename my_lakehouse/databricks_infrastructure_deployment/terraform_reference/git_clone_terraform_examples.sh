git clone --no-checkout --depth=1 --filter=tree:0 https://github.com/databricks/terraform-databricks-examples.git
cd terraform-databricks-examples
git sparse-checkout set --no-cone examples/aws-workspace-with-firewall examples/aws-databricks-uc
git checkout
