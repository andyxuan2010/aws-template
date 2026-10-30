# Module Documentation Standard

Each module's `README.md` is its canonical consumer guide. It should explain
the module's behavior and operational boundaries; the generated Terraform
reference is the source for exhaustive inputs, outputs, resources, and provider
constraints.

## Recommended README structure

Use the following order where the content applies:

1. **Title and purpose** — identify the AWS capability and the resources or
   behavior the module owns.
2. **Features** — summarize supported modes and important controls.
3. **Resources Created** — distinguish always-created resources, conditional
   resources, and dependencies that remain caller-owned.
4. **Prerequisites and Dependencies** — list required IDs, existing resources,
   permissions, account or Region constraints, and cross-module inputs.
5. **Provider Configuration** — state provider requirements and make clear that
   the calling root owns credentials, aliases, and configuration.
6. **Basic Usage** — show a concise HCL example and link to a runnable example
   when the module has one.
7. **Important Behavior and Secure Defaults** — document defaults, replacement
   behavior, costs, and security decisions that affect a plan or operation.
8. **Networking and Private Connectivity** and **Identity and Access** — add
   these sections when the module participates in those concerns.
9. **Naming and Tagging** — explain generated names, AWS limits, and tag merge
   behavior.
10. **Testing** — give exact commands and state whether tests mock providers or
    require AWS access.
11. **Known Limitations** — document unsupported cases and checks that tests
    cannot prove.
12. **Terraform Reference** — preserve the `terraform-docs` generated block.

Do not keep empty headings. Combine closely related sections for a small module
when that makes the guide easier to scan. Keep claims specific to the module's
implementation and tests.

## Examples and generated content

Prefer small Terraform examples that callers can copy safely. A checked-in
example directory is appropriate when it can be initialized, validated, and
tested independently; do not create example directories containing prose or
unvalidated snippets only. The existing AWS modules use mocked tests and
inline examples, so add standalone module examples as part of a concrete module
change.

The generated content between `BEGIN_TF_DOCS` and `END_TF_DOCS` is maintained by
the repository's `.terraform-docs.yml`. Refresh it with:

```powershell
terraform-docs -c .terraform-docs.yml modules/<module-name>
```

Descriptions in Terraform source should explain each public input and output.
Do not duplicate full generated input or output tables in the human-authored
sections.

## Optional architecture and operations notes

Add a module-level `docs/architecture.md` when diagrams or a separate design
explanation materially help consumers understand topology, trust boundaries,
resource relationships, or a complex request flow. Add focused operations
notes when a module has recovery, upgrade, or troubleshooting procedures that
do not fit clearly in its README. Keep the README as the consumer's entry point
and link to each supplemental page there. Do not add empty or generic pages to
every module.

## Related standards

- [Terraform Module Standard](../60-security-governance/terraform-module-standard.md)
- [Naming Convention](../60-security-governance/naming-convention.md)
- [Tagging Standard](../60-security-governance/tagging-standard.md)
- [Validation Summary](../70-validation/validation-summary.md)
- [Architecture Decision Records](../10-architecture/architecture-decision-records.md)
