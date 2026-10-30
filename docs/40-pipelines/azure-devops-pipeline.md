# Azure DevOps Pipeline

The root [`azure-pipelines.yml`](../../azure-pipelines.yml) provides native
Azure DevOps validation for pushes to `main`, `dev`, and `sbx`. Pull request
validation is provided by GitHub Actions; the ADO pipeline declares `pr: none`.

## Stages

1. **Validate** installs the pinned Terraform version, checks formatting, and
   initializes and validates the foundation example without a backend.
2. **Plan** creates an offline foundation plan with placeholder AWS credentials
   and no AWS API access.
3. **DetectModuleTargets** queries changed files for the Azure DevOps build and
   falls back to a Git diff if the API lookup is unavailable. Changes in a
   module select that module; a module removal and shared
   Terraform, examples, scripts, or pipeline configuration select all modules;
   documentation-only changes select none. Module names must use lowercase
   `snake_case` and are validated before CI matrix output is created.
4. **ValidateModules** runs `terraform init -backend=false`, `terraform
   validate`, and `terraform test` for each selected module in a matrix capped
   at four concurrent jobs.

The pipeline does not configure an AWS service connection, a remote state
backend, or an Apply stage. It validates module behavior without deploying AWS
resources.

## Agent and access requirements

The pipeline uses a Microsoft-hosted `ubuntu-24.04` agent. Change detection
uses `System.AccessToken` for the Azure DevOps build changes API; if that lookup
is unavailable, the pipeline uses the checked-out Git history. No Azure
variable group or AWS credential is required.

The change-detection step restricts Azure Pipelines logging commands, allows
only its three declared output variables, and marks those outputs read-only.
Keep the Azure DevOps job authorization scope limited to the project/repository
needed by this pipeline.

## Related pipeline

See the [GitHub Actions pipeline guide](github-actions-pipeline.md) for pull
request checks, Trivy scanning, GitHub release tags, and optional GitHub and
Azure DevOps repository publishing.
