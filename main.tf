resource "aws_api_gateway_authorizer" "this" {
  count = module.this.enabled ? 1 : 0

  name                   = module.this.id
  rest_api_id            = var.rest_api_id
  type                   = var.type
  authorizer_uri         = var.authorizer_uri
  authorizer_credentials = var.authorizer_credentials
  identity_source        = var.identity_source

  authorizer_result_ttl_in_seconds = var.result_ttl
}
