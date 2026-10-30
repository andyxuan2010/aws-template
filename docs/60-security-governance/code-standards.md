# Terraform Code Standards

Use these conventions for new and changed AWS modules. The detailed control
requirements are in the [Terraform Module Standard](terraform-module-standard.md).

## Interfaces and resources

- Declare provider source and version constraints in `terraform.tf`; configure
  providers and credentials only in the consuming root.
- Use explicit types and descriptions for variables and outputs. Prefer maps
  keyed by stable logical names for repeatable resources.
- Validate enumerations, ranges, formats, mutually exclusive settings, and
  unsafe combinations close to the module input boundary.
- Use resource preconditions for relationships that cannot be validated on a
  single input. Keep resource addresses stable and use `moved` blocks only when
  a tracked migration is necessary.
- Expose useful IDs and ARNs, not secret material. Mark sensitive outputs and
  avoid accepting secret values when a secret reference is sufficient.

## Security and operations

- Default to private networking, encryption, logging, and recovery controls
  where the service supports them and the module can manage them safely.
- Make public exposure and broad IAM permissions explicit opt-ins with
  actionable validation.
- Document AWS account, Region, quota, KMS key-policy, cross-account, and cost
  assumptions in the module README.
- Keep tags composable through `inherited_tags` and module-specific `tags`.
  Follow the [naming convention](naming-convention.md) and
  [tagging standard](tagging-standard.md).

Format with `terraform fmt -check -recursive`, run TFLint, and exercise mocked
module tests before requesting review.
