# Foundation Composition Guide

The [`examples/foundation`](../../examples/foundation/README.md) configuration
is a small demonstration root that combines five AWS modules. It shows module
composition and output-to-input wiring; it is not a production landing zone or
a preconfigured account deployment.

## Composition

The example creates a VPC with public and private subnets, a security group, an
S3 bucket, an IAM role, and an EC2 instance. The root configures the AWS
provider and passes values between modules. It does not create a remote
backend, organization structure, identity federation, or production approval
controls.

## Adapting the example

- Replace the placeholder bucket name with a globally unique name that follows
  your organization's naming rules.
- Select the AWS account, Region, VPC ranges, subnet ranges, and workload
  settings in the consuming root.
- Review IAM trust and permissions, security-group rules, image selection,
  encryption keys, logging, and cost controls for the target workload.
- Configure credentials and a protected Terraform state backend outside this
  example before using it to manage live resources.
- Add environment-specific values through the consuming repository's approved
  variable and secret management process.

The CI plan sets `offline_plan=true` and supplies a placeholder bucket name.
That plan verifies Terraform graph construction without querying or changing an
AWS account. It does not validate account permissions, service quotas, naming
availability, or live network reachability.

See [Module Usage and Dependencies](module-usage-and-dependencies.md) for
composition order and ownership contracts.
