mock_provider "aws" {}
run "http_api" {
  command = plan
  variables {
    region_code  = "use1"
    integrations = { lambda = { integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:api" } }
    routes       = { root = { route_key = "GET /", integration_key = "lambda" } }
  }
  assert {
    condition     = aws_apigatewayv2_stage.this.auto_deploy
    error_message = "The default stage must auto-deploy by default."
  }
}
run "reject_prod_without_logs" {
  command = plan
  variables {
    region_code = "use1"
    environment = "prod"
  }
  expect_failures = [aws_apigatewayv2_stage.this]
}
