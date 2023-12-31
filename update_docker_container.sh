# Run source /Users/xavier/Library/CloudStorage/Dropbox/Code/databricks-on-aws/update_docker_container.sh
cd ~
docker build -t dbx-on-aws:latest -f /Users/xavier/Library/CloudStorage/Dropbox/Code/databricks-on-aws/Dockerfile .
cd /Users/xavier/Library/CloudStorage/Dropbox/Code/databricks-on-aws