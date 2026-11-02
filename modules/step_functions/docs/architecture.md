# AWS Step Functions Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["step_functions module"]
  Module --> R1["aws_sfn_state_machine"]
```

The step_functions module declares 1 managed resource type(s), including `aws_sfn_state_machine`.

Resources that use `count` or `for_each` are gated by inputs such as `log_destination`. Review those inputs to see which optional components a deployment creates.

The module accepts 15 input(s), with 3 required.
It returns 4 output(s), including `state_machine_id`, `state_machine_arn`, `creation_date`, `tags`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
