# Validation Summary

Validation is designed to check Terraform structure and mocked module behavior
without connecting to an AWS account.

## Checks

| Check | GitHub Actions | Azure Pipelines | AWS access |
| --- | --- | --- | --- |
| Workflow lint | Yes | Not applicable | No |
| Terraform formatting | Yes | Yes | No |
| TFLint | Yes | No | No |
| Trivy IaC and secret scan | Yes | No | No |
| Foundation validation and offline plan | Yes | Yes | No; placeholder plan inputs |
| Changed-module validate and tests | Yes, matrix | Yes, matrix capped at four jobs | No; mocked providers |

GitHub Actions also supports pull request checks and optional publishing.
Azure Pipelines runs push validation on `main`, `dev`, and `sbx` and declares no
pull request trigger. Neither pipeline applies AWS resources.

Both module target detectors enforce lowercase `snake_case` module directory
names before serializing matrix values. Removing a module selects every
remaining module so the changed module catalog is covered.

## Local checks

From the repository root:

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

Mocked tests validate Terraform behavior for modeled inputs. They do not verify
AWS permissions, service quotas, account policy, live DNS, network reachability,
provider API behavior, or billable resource cleanup. Use an approved sandbox
integration process for those checks.
