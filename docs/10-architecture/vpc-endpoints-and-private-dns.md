# VPC Endpoints and Private DNS

This guide describes the network and DNS decisions around the
[`vpc_endpoints`](../../modules/vpc_endpoints/README.md) module. Private
connectivity is a composition of endpoint, route, security group, and DNS
resources; creating an endpoint alone does not guarantee that clients can
resolve or reach a service privately.

## Endpoint types

| Type | Network behavior | Caller responsibilities |
| --- | --- | --- |
| Gateway | Adds a service prefix-list route to selected route tables. | Select the route tables and review route precedence and service policy. |
| Interface | Creates endpoint network interfaces in selected subnets and resolves service names to private addresses when private DNS is enabled. | Select subnets and security groups, allow required client traffic, and ensure DNS support and host resolution are enabled on the VPC. |

## Design checks

- Select one or more subnets in the Availability Zones where clients need local
  connectivity. Check service and Region endpoint availability first.
- Limit endpoint security-group ingress to approved client sources and ports.
  Endpoint policies restrict service API access but do not replace IAM
  identity policies or resource policies.
- Enable private DNS only after checking for existing private hosted zones,
  resolver rules, and other endpoints that own the same service namespace.
- For hybrid clients, design Route 53 Resolver forwarding and on-premises DNS
  separately; VPC private DNS does not automatically configure corporate DNS.
- Gateway endpoints use route-table associations and do not create endpoint ENIs
  or endpoint security groups.
- Review cross-account access, endpoint service policies, IPv6 support, and
  data-transfer charges for the selected service.

## Validation

Use the module's mocked tests for input and plan-shape checks. In a sandbox,
also verify DNS answers from an attached client, endpoint security-group flow,
route selection, and service authorization. See the module
[README](../../modules/vpc_endpoints/README.md) and
[usage guide](../20-repository/module-usage-and-dependencies.md) for the exact
module interface and composition dependencies.
