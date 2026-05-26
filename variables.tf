variable "rest_api_id" {
  description = "ID of the REST API"
  type        = string
  validation {
    condition     = length(var.rest_api_id) > 0
    error_message = "rest_api_id must not be empty."
  }
}

variable "type" {
  description = "Authorizer type (TOKEN, REQUEST, COGNITO_USER_POOLS)"
  type        = string
  default     = "TOKEN"
  validation {
    condition     = contains(["TOKEN", "REQUEST", "COGNITO_USER_POOLS"], var.type)
    error_message = "type must be TOKEN, REQUEST, or COGNITO_USER_POOLS."
  }
}

variable "authorizer_uri" {
  description = "URI of the authorizer Lambda function"
  type        = string
  default     = null
}

variable "authorizer_credentials" {
  description = "IAM role ARN for invoking the authorizer"
  type        = string
  default     = null
}

variable "identity_source" {
  description = "Source of the identity token (e.g., method.request.header.Authorization)"
  type        = string
  default     = "method.request.header.Authorization"
}

variable "result_ttl" {
  description = "TTL for cached authorizer results in seconds"
  type        = number
  default     = 300
}
