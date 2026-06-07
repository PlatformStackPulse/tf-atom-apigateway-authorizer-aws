output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "authorizer_id" {
  description = "ID of the created API Gateway authorizer"
  value       = try(aws_api_gateway_authorizer.this[0].id, null)
}

output "authorizer_arn" {
  description = "ARN of the created API Gateway authorizer"
  value       = try(aws_api_gateway_authorizer.this[0].arn, null)
}
