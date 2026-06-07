# -----------------------------------------------------------------------------
# Module-Specific Variables
#
# Note: Standard labeling variables (enabled, namespace, tenant, environment,
# stage, name, delimiter, attributes, tags, label_order, etc.) are provided
# by context.tf via the tf-label module.
# -----------------------------------------------------------------------------

variable "rest_api_id" {
  description = "ID of the REST API"
  type        = string
}

variable "type" {
  description = "Type of the authorizer. Allowed values: TOKEN, REQUEST, COGNITO_USER_POOLS"
  type        = string
  default     = "REQUEST"

  validation {
    condition     = contains(["TOKEN", "REQUEST", "COGNITO_USER_POOLS"], var.type)
    error_message = "type must be one of: TOKEN, REQUEST, COGNITO_USER_POOLS."
  }
}

variable "authorizer_uri" {
  description = "Lambda invoke ARN for TOKEN or REQUEST authorizer"
  type        = string
  default     = null
}

variable "provider_arns" {
  description = "Cognito user pool ARNs for COGNITO_USER_POOLS type"
  type        = list(string)
  default     = []
}

variable "identity_source" {
  description = "Identity source header or context variable"
  type        = string
  default     = "method.request.header.Authorization"
}

variable "authorizer_result_ttl_in_seconds" {
  description = "TTL for cached authorizer results (0 = disabled)"
  type        = number
  default     = 300
}
