terraform output -json

terraform output -json | jq -r '.dbx_account_admin_access_key_id.value' > /tmp/credentials.txt

# Save output to variable
dev_ws_url=$(terraform output -json | jq -r '.dev_ws_url.value')
dev_ws_token=$(terraform output -json | jq -r '.dev_ws_token.value')

credentials="
[dbx_admin]
host = $dev_ws_url
account_id = 0c6d76dc-ee77-45f4-ac75-9a177cc435b4

