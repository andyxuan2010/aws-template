# AWS Identity and Access

AWS modules manage service roles and resource policies where the capability
requires them. The consuming root and AWS platform organization own the
identity that runs Terraform, account federation, Organizations policies, and
permission boundaries for the deployment process.

## Separate the identities

- **Terraform execution identity:** assumed by CI or an operator in the target
  account or through an approved cross-account role. Grant only the control
  plane actions needed for the selected root.
- **Service identity:** an IAM role trusted by an AWS service such as EC2,
  Lambda, ECS, CloudTrail, or Config. Keep its trust policy scoped to the
  service and, where supported, source account and resource.
- **Workload identity:** credentials or role sessions used by application
  workloads. Prefer instance profiles or task/function execution roles over
  static access keys.

## Policy design

- Keep trust policies separate from permission policies.
- Scope resource ARNs, actions, and principals to the narrowest useful values.
- Use permissions boundaries and organization SCPs as guardrails; they do not
  replace least-privilege role policies.
- Avoid wildcard principals and broad administrative actions. Document any
  unavoidable wildcard with its service-specific reason.
- Review KMS key policies alongside IAM policies. Access requires both policy
  layers to permit the operation where both apply.
- Keep service-linked roles and organization delegated-administrator setup
  outside a module unless that lifecycle is explicitly part of its contract.

See [`iam_role`](../../modules/iam_role/README.md),
[module usage and dependencies](../20-repository/module-usage-and-dependencies.md),
and the [Terraform Module Standard](terraform-module-standard.md).
