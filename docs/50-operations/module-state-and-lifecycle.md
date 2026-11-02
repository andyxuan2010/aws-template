# Module State and Lifecycle Ownership

This repository supplies child modules and an offline example. It does not own
the Terraform state for a consuming AWS account. The root configuration that
calls these modules owns state, locking, credentials, backups, imports, and
resource lifecycle operations.

## Consumer responsibilities

- Use an approved remote state backend with restricted access, encryption, and
  recovery controls appropriate to the account and environment.
- Keep backend settings and state separate from module source. Never commit
  state files, state backups, credentials, or secret values.
- Review plans for replacement, deletion protection, retention, force-destroy,
  route changes, and service-specific irreversible settings.
- Keep stable module keys and resource addresses. If a refactor changes an
  address, plan and document a state move in the consuming root.
- Test recovery procedures and imports in a sandbox before using them for a
  production incident.

The example's backend-free offline plan is only a validation harness. It does
not establish a recommended state backend or prove a consumer's recovery plan.
See the [Terraform Module Standard](../60-security-governance/terraform-module-standard.md)
for resource lifecycle requirements and
[Module Usage and Dependencies](../20-repository/module-usage-and-dependencies.md)
for ownership boundaries.
