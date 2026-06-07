resource "aws_api_gateway_authorizer" "this" {
  count = module.this.enabled ? 1 : 0

  name        = module.this.id
  rest_api_id = var.rest_api_id
  type        = var.type

  # TOKEN / REQUEST type fields (ignored when type = COGNITO_USER_POOLS)
  authorizer_uri                   = var.type != "COGNITO_USER_POOLS" ? var.authorizer_uri : null
  identity_source                  = var.identity_source
  authorizer_result_ttl_in_seconds = var.authorizer_result_ttl_in_seconds

  # COGNITO_USER_POOLS type fields (ignored for TOKEN/REQUEST)
  provider_arns = var.type == "COGNITO_USER_POOLS" ? var.provider_arns : null
}
