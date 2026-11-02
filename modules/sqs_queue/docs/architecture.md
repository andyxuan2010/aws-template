# SQS queue Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["sqs_queue module"]
  Module --> R1["aws_sqs_queue"]
```

The sqs_queue module declares 1 managed resource type(s), including `aws_sqs_queue`.

The module accepts 20 input(s), with 1 required.
It returns 4 output(s), including `queue_id`, `queue_arn`, `queue_name`, `queue_url`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
