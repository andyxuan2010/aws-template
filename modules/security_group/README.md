# Security group module

AWS counterpart to the Azure template's `nsg` module. It creates one security
group and uses standalone rule resources to avoid rule ownership conflicts.
Ingress and egress are both denied by default. Callers must declare the exact
destinations a workload requires.

```hcl
module "app_sg" {
  source = "../../modules/security_group"

  vpc_id      = module.vpc.vpc_id
  region_code = "use1"
  ingress_rules = {
    https = {
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "10.20.0.0/16"
    }
  }
}
```

Each rule must specify exactly one IPv4 CIDR, IPv6 CIDR, prefix list, or
referenced security group. Public ingress from `0.0.0.0/0` or `::/0` is rejected
unless `allow_public_ingress = true` is explicitly set. Protocol-specific rules
must define a valid port range.
