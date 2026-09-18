# Amazon API Gateway v2

Creates an HTTP or WebSocket API with integrations, routes, and a stage.

## Features

- Typed integrations and routes, HTTP CORS, access logs, and optional endpoint disabling.

## Resources Created

One API, its integrations and routes, and one stage.

## Prerequisites and Dependencies

Integration targets, invocation permissions, authorizers, VPC links, and log groups are caller-owned.

## Basic Usage

```hcl
module "api" { source="./modules/api_gateway" region_code="use1" integrations={lambda={integration_uri=aws_lambda_function.api.invoke_arn}} routes={root={route_key="GET /",integration_key="lambda"}} }
```

## Important Behavior and Secure Defaults

Production requires access logging. Authorization defaults to NONE so each route's exposure remains visible in code.

## Naming and Tagging

Names and tags follow repository standards.

## Testing

Run backend-free init, validate, and test.

## Known Limitations

REST API v1, domain names, authorizers, usage plans, and Lambda permissions are separate concerns.

## Terraform Reference

Generated from source; do not edit manually.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_destination_arn"></a> [access\_log\_destination\_arn](#input\_access\_log\_destination\_arn) | CloudWatch Logs destination ARN. | `string` | `null` | no |
| <a name="input_access_log_format"></a> [access\_log\_format](#input\_access\_log\_format) | Access log JSON format. | `string` | `"{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"requestTime\":\"$context.requestTime\",\"routeKey\":\"$context.routeKey\",\"status\":\"$context.status\",\"responseLength\":\"$context.responseLength\"}"` | no |
| <a name="input_auto_deploy"></a> [auto\_deploy](#input\_auto\_deploy) | Automatically deploy stage changes. | `bool` | `true` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | Optional HTTP API CORS policy. | `object({ allow_credentials = optional(bool, false), allow_headers = optional(set(string), []), allow_methods = optional(set(string), []), allow_origins = set(string), expose_headers = optional(set(string), []), max_age = optional(number) })` | `null` | no |
| <a name="input_disable_execute_api_endpoint"></a> [disable\_execute\_api\_endpoint](#input\_disable\_execute\_api\_endpoint) | Disable the default execute-api endpoint. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit instance. | `string` | `"001"` | no |
| <a name="input_integrations"></a> [integrations](#input\_integrations) | Integrations keyed by stable logical name. | `map(object({ integration_type = optional(string, "AWS_PROXY"), integration_uri = string, integration_method = optional(string, "POST"), payload_format_version = optional(string, "2.0"), timeout_milliseconds = optional(number, 30000), connection_type = optional(string, "INTERNET"), connection_id = optional(string) }))` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Optional API name. | `string` | `""` | no |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | HTTP or WEBSOCKET protocol. | `string` | `"HTTP"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Routes keyed by stable logical name. | `map(object({ route_key = string, integration_key = string, authorization_type = optional(string, "NONE"), authorizer_id = optional(string), authorization_scopes = optional(set(string), []), api_key_required = optional(bool, false) }))` | `{}` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | Deployment stage name. | `string` | `"$default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | API-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_arn"></a> [api\_arn](#output\_api\_arn) | API ARN. |
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | Default API endpoint. |
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | API ID. |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | API execution ARN. |
| <a name="output_invoke_url"></a> [invoke\_url](#output\_invoke\_url) | Stage invoke URL. |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | Stage ARN. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective tags. |
<!-- END_TF_DOCS -->
