# Amazon API Gateway v2 Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["api_gateway module"]
  Module --> R1["aws_apigatewayv2_api"]
  Module --> R2["aws_apigatewayv2_integration"]
  Module --> R3["aws_apigatewayv2_route"]
  Module --> R4["aws_apigatewayv2_stage"]
```

The api_gateway module declares 4 managed resource type(s), including `aws_apigatewayv2_api`, `aws_apigatewayv2_integration`, `aws_apigatewayv2_route`, `aws_apigatewayv2_stage`.

Resources that use `count` or `for_each` are gated by inputs such as `cors_configuration`, `integrations`, `routes`, `access_log_destination_arn`. Review those inputs to see which optional components a deployment creates.

The module accepts 16 input(s), with 1 required.
It returns 7 output(s), including `api_id`, `api_arn`, `api_endpoint`, `execution_arn`, `stage_arn`, `invoke_url`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
