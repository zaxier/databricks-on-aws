
# Ask for tag from user
echo "Enter tag for docker container: "
read tag

# Build docker container
# cd ~
# docker build -t dbx-on-aws:v1.0.0 -f /Users/xavier/Library/CloudStorage/Dropbox/Code/databricks-on-aws/Dockerfile .
cd ~
docker build -t dbx-on-aws:$tag -f /Users/xavier/Library/CloudStorage/Dropbox/Code/databricks-on-aws/Dockerfile .

# Update docker-compose file replace everything after image: with new tag
sed -i '' "s/image: dbx-on-aws:.*/image: dbx-on-aws:$tag/g" /Users/xavier/Library/CloudStorage/Dropbox/Code/databricks-on-aws/compose-dev.yaml

cd /Users/xavier/Library/CloudStorage/Dropbox/Code/databricks-on-aws