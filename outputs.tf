output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "id" {
  description = "ID of the authorizer"
  value       = try(aws_api_gateway_authorizer.this[0].id, null)
}
