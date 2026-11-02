# ElastiCache Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["elasticache module"]
  Module --> R1["aws_elasticache_subnet_group"]
  Module --> R2["aws_elasticache_replication_group"]
```

The elasticache module declares 2 managed resource type(s), including `aws_elasticache_subnet_group`, `aws_elasticache_replication_group`.

The module accepts 18 input(s), with 6 required.
It returns 5 output(s), including `replication_group_id`, `replication_group_arn`, `primary_endpoint_address`, `reader_endpoint_address`, `port`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
