# DynamoDB table Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["dynamodb_table module"]
  Module --> R1["aws_dynamodb_table"]
```

The dynamodb_table module declares 1 managed resource type(s), including `aws_dynamodb_table`.

Resources that use `count` or `for_each` are gated by inputs such as `attributes`, `global_secondary_indexes`, `local_secondary_indexes`, `ttl_attribute_name`. Review those inputs to see which optional components a deployment creates.

The module accepts 23 input(s), with 3 required.
It returns 5 output(s), including `table_id`, `table_name`, `table_arn`, `stream_arn`, `stream_label`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
