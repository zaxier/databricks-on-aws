// output token for other modules
output "databricks_token" {
  value     = databricks_token.pat.token_value
  sensitive = true
}