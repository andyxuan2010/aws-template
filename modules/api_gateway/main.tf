resource "aws_apigatewayv2_api" "this" {
  name                         = local.name
  protocol_type                = upper(var.protocol_type)
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  tags                         = local.tags
  dynamic "cors_configuration" {
    for_each = var.cors_configuration == null ? [] : [var.cors_configuration]
    content {
      allow_credentials = cors_configuration.value.allow_credentials
      allow_headers     = cors_configuration.value.allow_headers
      allow_methods     = cors_configuration.value.allow_methods
      allow_origins     = cors_configuration.value.allow_origins
      expose_headers    = cors_configuration.value.expose_headers
      max_age           = cors_configuration.value.max_age
    }
  }
  lifecycle {
    precondition {
      condition     = upper(var.protocol_type) == "HTTP" || var.cors_configuration == null
      error_message = "CORS is supported only for HTTP APIs."
    }
  }
}
resource "aws_apigatewayv2_integration" "this" {
  for_each               = var.integrations
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = each.value.integration_type
  integration_uri        = each.value.integration_uri
  integration_method     = each.value.integration_method
  payload_format_version = each.value.payload_format_version
  timeout_milliseconds   = each.value.timeout_milliseconds
  connection_type        = each.value.connection_type
  connection_id          = each.value.connection_id
}
resource "aws_apigatewayv2_route" "this" {
  for_each             = var.routes
  api_id               = aws_apigatewayv2_api.this.id
  route_key            = each.value.route_key
  target               = "integrations/${aws_apigatewayv2_integration.this[each.value.integration_key].id}"
  authorization_type   = each.value.authorization_type
  authorizer_id        = each.value.authorizer_id
  authorization_scopes = each.value.authorization_scopes
  api_key_required     = each.value.api_key_required
}
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy
  tags        = local.tags
  dynamic "access_log_settings" {
    for_each = var.access_log_destination_arn == null ? [] : [1]
    content {
      destination_arn = var.access_log_destination_arn
      format          = var.access_log_format
    }
  }
  lifecycle {
    precondition {
      condition     = var.environment != "prod" || var.access_log_destination_arn != null
      error_message = "Production APIs require access logging."
    }
  }
}
