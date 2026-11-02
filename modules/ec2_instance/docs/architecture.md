# EC2 instance Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["ec2_instance module"]
  Module --> R1["aws_instance"]
```

The ec2_instance module declares 1 managed resource type(s), including `aws_instance`.

The module accepts 21 input(s), with 4 required.
It returns 7 output(s), including `instance_id`, `instance_arn`, `name`, `private_ip`, `private_dns`, `public_ip`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
