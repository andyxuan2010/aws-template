# DevSecOps and GitOps Controls

The repository uses reviewed changes as the promotion point for reusable
Terraform code. CI verifies the source before branch synchronization or stage
publication; those publishing jobs do not provision AWS resources.

## Change control

- Develop changes through pull requests into `main`, `dev`, or `sbx` and require
  the repository's branch protection and required checks.
- Run GitHub Actions static checks, secret and IaC scanning, offline planning,
  and module tests. Azure Pipelines adds native push validation on those
  branches.
- Review workflow changes, module interface changes, and generated docs as code
  changes. Protect publishing destinations because synchronization updates
  matching branches and optional tags.
- Keep AWS account credentials and deployment approvals in the consuming root
  repository. This module catalog has no live Apply path.

## Secret and configuration handling

Trivy scans the repository filesystem for misconfiguration and secret findings
at HIGH and CRITICAL severity. The scan is enabled unless
`ENABLE_IAC_SECRET_SCAN` is exactly `false`; the current repository setting is
`true`. Do not place secret values, Terraform state, credentials, or
environment-specific backend configuration in this repository.

Publication credentials are scoped to their destinations. Preflight reports
input presence without printing values. Review tokens and repository variables
after destination changes, and rotate exposed credentials through the owning
service.
