# GitHub Actions Terraform Pipeline

The repository workflow in [`.github/workflows/terraform.yml`](../.github/workflows/terraform.yml)
is an AWS-template validation and publication pipeline. It does not deploy AWS
resources from this template repository.

## Pipeline flow

1. **Static IaC and Security Validation** runs Terraform formatting, TFLint,
   and Trivy misconfiguration/secret scanning.
2. **Check Required Secrets and Variables** reports the presence of optional
   GitHub stage and Azure DevOps development publication inputs without printing
   secret values.
3. **Validate and Plan** initializes the foundation example without a backend,
   validates it, and creates an offline plan using placeholder credentials.
4. **Detect Module Harness Targets** selects changed modules for the validation
   matrix. Root Terraform, example, script, or lint configuration changes select
   every module; documentation-only changes select none. If a push base or head
   commit cannot be resolved, it safely falls back to selecting every module.
5. **Validate Module** runs backend-free initialization, validation, and mocked
   tests for each selected module. The FortiGate modules are included in this
   matrix: `fortigate`, `gateway_load_balancer`, and `route_manager`.
6. **Create Git Tag** is optional and runs only when
   `ENABLE_GITHUB_RELEASE_TAG=true`. It creates the next patch-style semantic
   tag after successful validation.
7. **Publish Github Demo Repo** publishes a clean snapshot when
   `STAGE_REPOSITORY` and `STAGE_REPO_TOKEN` are configured.
8. **Publish ADO Dev Repo** synchronizes Git history when
   `ADO_DEV_REPOSITORY` and `ADO_DEV_REPO_PAT` are configured.

There is intentionally no ADO production/sandbox publication job. There is
also no active AWS **Apply** job in this template: the repository has no
deployment backend or AWS credential path, and the engineering standard
requires deployment workflows to be separate, environment-protected, and
explicitly approved.

## Publication configuration

| Name | Type | Purpose |
| --- | --- | --- |
| `STAGE_REPOSITORY` | Repository variable | GitHub destination in `owner/repository` form. Defaults to `andyxuan2010/aws-template` for compatibility with the existing stage flow. |
| `STAGE_REPO_TOKEN` | Secret | Token scoped to the GitHub stage destination. |
| `ADO_DEV_REPOSITORY` | Repository variable | Azure DevOps destination in `organization/project/_git/repository` form. |
| `ADO_DEV_REPO_PAT` | Secret | PAT scoped to the Azure DevOps development destination. |
| `ENABLE_GITHUB_RELEASE_TAG` | Repository variable | Set exactly to `true` to enable release-tag creation; unset or any other value skips it. |

Publishing is skipped for pull requests and when the current repository matches
the configured GitHub stage destination, preventing a stage-repository loop.
Both destinations are force-updated by design; protect them and scope their
tokens accordingly.

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
