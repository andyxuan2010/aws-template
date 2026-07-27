# VPC module

Creates a VPC with a map of public and private subnets, explicit route tables,
an optional internet gateway, and optional per-Availability-Zone NAT gateways.
This combines the Azure template's `vnet`, `subnet`, and `route_table` building
blocks in the form most commonly composed in AWS.

```hcl
module "vpc" {
  source = "../../modules/vpc"

  workload   = "platform"
  region_code = "use1"
  environment = "dev"
  cidr_block  = "10.20.0.0/16"

  nat_gateway_mode = "per_az"

  subnets = {
    public-a  = { cidr_block = "10.20.0.0/24", availability_zone = "us-east-1a", public = true }
    private-a = { cidr_block = "10.20.10.0/24", availability_zone = "us-east-1a" }
  }
}
```

`nat_gateway_mode` is explicit: `none` (default), `single` (lower cost and a
cross-AZ failure dependency), or `per_az` (recommended for resilient production
egress). The module fails rather than silently leaving a requested per-AZ NAT
topology incomplete. IPv6 and externally owned VPC Flow Log destinations are
also supported.
