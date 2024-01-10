terraform apply -auto-approve

terraform output -json | jq -r '.dbx_account_admin_access_key_id.value' > /tmp/credentials.txt

# Save output to variable
access_key_id=$(terraform output -json | jq -r '.dbx_account_admin_access_key_id.value')
secret_access_key=$(terraform output -json | jq -r '.dbx_account_admin_secret_access_key.value')

credentials="
[dbx_admin]
aws_access_key_id = $access_key_id
aws_secret_access_key = $secret_access_key"

echo "$credentials" >> ~/.aws/credentials

config="
[profile dbx_admin]
region = ap-southeast-2
output = text
"

echo "$config" >> ~/.aws/config
