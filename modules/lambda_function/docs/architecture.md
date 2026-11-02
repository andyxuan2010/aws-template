# Lambda function Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["lambda_function module"]
  Module --> R1["aws_lambda_function"]
```

The lambda_function module declares 1 managed resource type(s), including `aws_lambda_function`.

Resources that use `count` or `for_each` are gated by inputs such as `environment_variables`, `vpc_config`, `dead_letter_target_arn`. Review those inputs to see which optional components a deployment creates.

The module accepts 29 input(s), with 2 required.
It returns 6 output(s), including `function_name`, `function_arn`, `qualified_arn`, `version`, `invoke_arn`, `last_modified`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
