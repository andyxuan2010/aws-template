# GitHub Actions Terraform Pipeline

The repository workflow in [`.github/workflows/terraform.yml`](../../.github/workflows/terraform.yml)
is an AWS-template validation and publication pipeline. It does not deploy AWS
resources from this template repository.

Third-party actions are pinned to full commit SHAs or a container digest.
Workflow permissions default to `contents: read`, with write access granted
only to the release-tag job. The publication preflight receives secret-presence
booleans; publishing tokens are mapped only into gated publishing jobs.
Validation checkouts do not persist their `GITHUB_TOKEN` in Git configuration,
and Trivy scanning is a required static-validation step. Publishing PATs stay
in job environment variables and Git asks a temporary, host-scoped helper for
credentials; PATs are not embedded in remote URLs or command arguments.

The repository also includes a native Azure DevOps pipeline in
[`azure-pipelines.yml`](../../azure-pipelines.yml). It runs on pushes to
`main`, `dev`, and `sbx`, performs formatting and foundation validation, makes
an offline foundation plan with placeholder AWS credentials, and detects
changed modules for validation and tests in a parallel matrix capped at four
jobs. Shared Terraform, example, and script changes select every module;
documentation-only changes select none. It does not use a remote backend,
require cloud service connections, or apply resources. Pull request validation
is provided by GitHub Actions.

## Pipeline flow

1. **Static IaC and Security Validation** runs Terraform formatting, TFLint,
   and Trivy misconfiguration/secret scanning.
2. **Check Required Secrets and Variables** reports the presence of optional
   GitHub stage and Azure DevOps development and production/sandbox publication
   inputs without printing secret values.
3. **Validate and Plan** initializes the foundation example without a backend,
   validates it, and creates an offline plan using placeholder credentials.
4. **Detect Module Harness Targets** selects changed modules for the validation
   matrix. Root Terraform, example, script, or lint configuration changes select
   every module; removing a module also selects every current module.
   Documentation-only changes select no modules, but they still run this
   workflow so validated documentation updates can be synchronized to the ADO
   repositories. The detector validates lowercase `snake_case` module names
   before creating the matrix. If a push base or head commit cannot be
   resolved, it safely falls back to selecting every module.
5. **Validate Module** runs backend-free initialization, validation, and mocked
   tests for each selected module. The FortiGate modules are included in this
   matrix: `fortigate`, `gateway_load_balancer`, and `route_manager`.
6. **Create Git Tag** is optional and runs only when
   `ENABLE_GITHUB_RELEASE_TAG=true`. It creates the next patch-style semantic
   tag after successful validation; a dedicated concurrency group serializes
   tag allocation across branches.
7. **Publish Github Demo Repo** publishes a clean snapshot when
   `STAGE_REPOSITORY` and `STAGE_REPO_TOKEN` are configured.
8. **Publish ADO Dev Repo** synchronizes Git history when
   `ADO_DEV_REPOSITORY` and `ADO_DEV_REPO_PAT` are configured. It mirrors the
   triggering `main`, `dev`, or `sbx` branch and an optional release tag.
9. **Publish ADO Production/Sandbox Repo** synchronizes Git history when
   `PUBLISH_ADO_PROD=true`, `ADO_PROD_REPOSITORY`, and `ADO_PROD_REPO_PAT` are
   configured. It mirrors the triggering `main`, `dev`, or `sbx` branch and an
   optional release tag to the same Azure DevOps repository.

There is no active AWS **Apply** job in this template: the repository has no
deployment backend or AWS credential path, and the engineering standard
requires deployment workflows to be separate, environment-protected, and
explicitly approved.

## Publication configuration

| Name | Type | Purpose |
| --- | --- | --- |
| `STAGE_REPOSITORY` | Repository variable | GitHub destination in `owner/repository` form. Defaults to `andyxuan2010/aws-template` for compatibility with the existing stage flow. |
| `STAGE_REPO_TOKEN` | Secret | Token scoped to the GitHub stage destination. |
| `ADO_DEV_REPOSITORY` | Repository variable | Azure DevOps destination in `organization/project/_git/repository` form. |
| `ADO_DEV_REPO_PAT` | Secret | PAT scoped to the Azure DevOps development destination. Keep it at repository or organization scope because preflight is not attached to an environment. |
| `PUBLISH_ADO_PROD` | Repository variable | Must be exactly `true` to enable production/sandbox publishing. |
| `ADO_PROD_REPOSITORY` | Repository variable | Azure DevOps destination in `organization/project/_git/repository` form. |
| `ADO_PROD_REPO_PAT` | Secret | PAT scoped to the Azure DevOps production/sandbox destination. The preflight job is not attached to `prod`, so use a repository or organization secret unless preflight scoping is changed. |
| `ENABLE_GITHUB_RELEASE_TAG` | Repository variable | Set exactly to `true` to enable release-tag creation; unset or any other value skips it. |

Publishing is skipped for pull requests and when the current repository matches
the configured GitHub stage destination, preventing a stage-repository loop.
Both ADO repository destinations receive force-updated branches and optional
tags by design; protect them and scope their PATs accordingly. The GitHub stage
publisher sends a clean snapshot to its configured destination.

The ADO production/sandbox job uses the protected GitHub `prod` environment and
one combined Azure DevOps destination. It force-updates the matching branch
(`main`, `dev`, or `sbx`) and, when release tagging is enabled, the matching
release tag.

## Local validation

Run the same credential-free checks before opening a pull request:

```powershell
terraform fmt -check -recursive
tflint --init
tflint --recursive --format compact
./scripts/Test-TerraformModules.ps1
terraform -chdir=examples/foundation init -backend=false -input=false
terraform -chdir=examples/foundation validate -no-color
terraform -chdir=examples/foundation plan -input=false -no-color -lock=false -refresh=false `
  -var="offline_plan=true" -var="bucket_name=ccoecicheck-foundation-placeholder"
```
