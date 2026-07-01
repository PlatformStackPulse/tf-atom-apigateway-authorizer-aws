# Unit Tests for tf-atom-apigateway-authorizer-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Assertions only reference values that are KNOWN at plan time (tf-label id,
# resource count, and input pass-throughs). Computed attributes such as the
# authorizer's real id/arn are unknown under a mock provider, so they are
# never asserted on directly.
#
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose

mock_provider "aws" {}

# Standard tf-label inputs + this module's required inputs.
variables {
  # tf-label context
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-specific required input
  rest_api_id = "abcd123456"

  # Module-specific optional inputs with explicit sample values
  type            = "REQUEST"
  authorizer_uri  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:authorizer/invocations"
  identity_source = "method.request.header.Authorization"
}

# ---------------------------------------------------------------------------
# Test: module creates the authorizer when enabled (the default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled"
  }

  assert {
    condition     = length(aws_api_gateway_authorizer.this) == 1
    error_message = "exactly one authorizer should be planned when enabled"
  }

  assert {
    condition     = aws_api_gateway_authorizer.this[0].name == "eg-test-thing"
    error_message = "authorizer name should equal the tf-label id 'eg-test-thing'"
  }

  assert {
    condition     = aws_api_gateway_authorizer.this[0].rest_api_id == "abcd123456"
    error_message = "rest_api_id should be passed through unchanged"
  }

  assert {
    condition     = aws_api_gateway_authorizer.this[0].type == "REQUEST"
    error_message = "authorizer type should be passed through unchanged"
  }
}

# ---------------------------------------------------------------------------
# Test: COGNITO_USER_POOLS type wires provider_arns and drops authorizer_uri
# ---------------------------------------------------------------------------
run "cognito_type_wiring" {
  command = plan

  variables {
    type          = "COGNITO_USER_POOLS"
    provider_arns = ["arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_ABCDEFGHI"]
  }

  assert {
    condition     = aws_api_gateway_authorizer.this[0].type == "COGNITO_USER_POOLS"
    error_message = "authorizer type should be COGNITO_USER_POOLS"
  }

  assert {
    condition     = aws_api_gateway_authorizer.this[0].provider_arns == toset(["arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_ABCDEFGHI"])
    error_message = "provider_arns should be wired for COGNITO_USER_POOLS type"
  }

  assert {
    condition     = aws_api_gateway_authorizer.this[0].authorizer_uri == null
    error_message = "authorizer_uri must be null for COGNITO_USER_POOLS type"
  }
}

# ---------------------------------------------------------------------------
# Test: disabling the module creates nothing
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when the module is disabled"
  }

  assert {
    condition     = length(aws_api_gateway_authorizer.this) == 0
    error_message = "no authorizer should be planned when the module is disabled"
  }

  assert {
    condition     = output.authorizer_id == null
    error_message = "authorizer_id output should be null when the module is disabled"
  }
}
