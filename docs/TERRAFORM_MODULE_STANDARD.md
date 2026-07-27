# CCOE Terraform Module Engineering Standard

## 1. Purpose and authority

This document is the tracked source of truth for reusable Terraform modules in
this repository. The Azure template is a useful source of CCOE conventions, but
it is not the design authority for AWS.

When requirements conflict, use this priority:

1. AWS service and security constraints
2. Terraform and AWS provider correctness
3. AWS Well-Architected and CCOE security requirements
4. Cross-cloud CCOE consistency
5. Compatibility with an existing Azure implementation

Record intentional exceptions in the affected module README and in this
document when the exception applies repository-wide.

## 2. Module boundaries

Modules must own a cohesive capability, not merely wrap one resource and not
attempt to model an entire landing zone in one stateful unit.

The repository distinguishes:

- **Primitive modules**, such as VPC, security group, bucket, IAM role, and KMS
  key. These are reusable by workloads and higher-level compositions.
- **Foundation compositions**, which combine primitives for a repeatable
  platform pattern.
- **Landing-zone modules**, which will manage Organizations, accounts,
  centralized audit/security services, identity, and shared networking.

Primitive modules must not configure providers, backends, credentials, or
organization-wide state.

## 3. Required structure

Every module must contain:

```text
modules/<module_name>/
├── README.md
├── terraform.tf
├── variables.tf
├── locals.tf
├── main.tf
├── outputs.tf
└── tests/
    └── *.tftest.hcl
```

Large modules may split `main.tf` into files named for cohesive resource groups.
Variables and outputs should be ordered logically and remain easy to discover.

## 4. Provider and Terraform versions

- Child modules declare provider source addresses and a tested compatibility
  range but never contain `provider` blocks.
- Root compositions configure providers and authentication.
- Root deployment repositories commit dependency lock files. This module
  library does not commit per-module lock files.
- CI must test the supported Terraform and provider range regularly.
- Version constraints must be updated intentionally after compatibility tests;
  they must not float without an upper compatibility boundary.

## 5. Interface design

- Use exact object, map, set, list, number, bool, and string types.
- Do not use `any` for a public interface.
- Use maps keyed by stable logical names for repeatable child resources.
- Prefer optional object attributes with safe defaults.
- Validate formats, enumerations, ranges, mutually exclusive values, and unsafe
  combinations as early as Terraform permits.
- Use resource preconditions for validation that depends on multiple inputs.
- Avoid boolean collections that permit contradictory states; use a single
  mode variable such as `nat_gateway_mode = "none" | "single" | "per_az"`.
- Keep an advanced escape hatch only when typed inputs cannot represent a
  legitimate provider capability.
- Breaking input changes require a major module version once modules are
  released independently.

## 6. Secure defaults

- Default-deny inbound network access.
- Public exposure must require an explicit opt-in.
- Encrypt data at rest and in transit where the service supports it.
- Enable versioning, recovery, rotation, and logging where their operational
  cost is reasonable and predictable.
- Do not create wildcard IAM permissions or trust relationships implicitly.
- Prefer temporary role credentials to access keys.
- Do not accept secrets as ordinary module inputs when a service reference can
  be used instead.
- Mark outputs `sensitive` when they can reveal credentials, secret material, or
  sensitive policy context.
- Destructive options such as `force_destroy` must default to false and be
  blocked for production where feasible.
- Resource deletion windows should use the safest service-supported default.

## 7. Naming

The default regional shape is:

```text
<resource-type>-<workload>-<region-code>-<environment>-<instance>
```

Global resources omit the region. Explicit names remain supported when AWS
uniqueness, migration, or interoperability requires them.

Generated names must obey AWS service constraints. For example, AWS reserves
security-group names beginning with `sg-`, so the module uses `secgrp-`.

Stable Terraform map keys are identity, not display labels. Renaming a map key
can replace a resource and must be reviewed as a lifecycle change.

## 8. Tagging

Root compositions own enterprise tag normalization and pass it through
`inherited_tags`. Modules merge in this order:

```hcl
merge(var.inherited_tags, var.tags, { Name = local.name })
```

Resource-specific child tags may be inserted before the final `Name` tag.
Modules must not silently rewrite enterprise tag values. Provider
`default_tags` may add an organization baseline, but explicit inherited tags
keep plans and tests self-describing.

## 9. Lifecycle and dependency rules

- Avoid unnecessary `depends_on`; use expression references for normal graph
  dependencies.
- Use `create_before_destroy` only when the AWS API supports name coexistence.
- Never use broad `ignore_changes` to hide unmanaged drift.
- Do not use provisioners unless no provider or service-native option exists.
- Outputs expose stable identifiers and maps keyed like the corresponding input.
- Modules must not silently omit a requested dependency. They should fail with
  an actionable precondition when a requested topology cannot be built.

## 10. Testing and validation

Every change must pass:

1. `terraform fmt -check -recursive`
2. `terraform validate`
3. mocked `terraform test` for all modules
4. `tflint` with the AWS ruleset
5. static security scanning
6. `git diff --check`

Tests must cover:

- secure defaults
- generated names and stable outputs
- representative optional features
- unsafe input rejection
- important resource relationships

Mocked tests are required for pull requests and do not need AWS credentials.
Selected live integration tests should run separately in a dedicated sandbox
account before a release. Live tests must use temporary credentials, cost
controls, unique names, and guaranteed cleanup.

## 11. CI/CD safety

The template repository pipeline is validation-only until deployment is
explicitly designed and approved.

It must not:

- request AWS credentials or an OIDC token
- initialize a remote backend
- run `terraform plan` against an AWS account
- run `terraform apply` or `terraform destroy`
- publish artifacts to AWS

GitHub Actions receive least-privilege `contents: read` permission. Deployment
workflows, when introduced, must be separate, environment-protected, and use
short-lived role credentials.

## 12. Documentation and change tracking

Each module README documents:

- purpose and ownership boundary
- secure defaults
- minimum and recommended examples
- input interactions and cost implications
- destructive or replacement behavior
- known AWS constraints

Repository-wide decisions belong in this standard. Material design decisions
that need alternatives and consequences recorded belong in `docs/adr/`.
Released modules use semantic versioning and a changelog.

## 13. Review checklist

- Is the module boundary cohesive?
- Can invalid or unsafe states be rejected earlier?
- Does the default avoid public access and excessive permissions?
- Are encryption, recovery, logging, and deletion behavior explicit?
- Are names AWS-compliant and map keys stable?
- Are tags merged without unexpected rewriting?
- Are outputs useful without exposing sensitive information?
- Are all optional modes covered by tests?
- Does the change introduce cost, replacement, or cross-account implications?
- Should the improvement also be proposed for the Azure template?
