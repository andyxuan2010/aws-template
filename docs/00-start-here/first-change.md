# First Change Walkthrough

Use this walkthrough to make a small, reviewable change without AWS access. The repository validates reusable modules and an example composition; it does not authorize or perform a live AWS apply.

## 1. Find the change surface

- For a reusable capability, start in `modules/<module-name>/` and the [Modules Index](../20-repository/modules-index.md).
- For composition behavior, inspect `examples/foundation/` and the [Foundation Composition Guide](../20-repository/foundation-composition-guide.md).
- For workflow behavior, inspect `.github/workflows/terraform.yml`, `azure-pipelines.yml`, and the scripts they call.
- For repository guidance, update the relevant `docs/` page and its navigation links.

The [Repository Map](repo-map.md) summarizes the directory layout. A module in the catalog is not automatically part of a consumer's deployment.

## 2. Read before editing

Read the module README, Terraform source, mocked tests, and any example that uses the module. Check the [Module Usage and Dependencies](../20-repository/module-usage-and-dependencies.md) guide for caller-owned inputs and cross-module contracts. Confirm who owns provider configuration, credentials, account and Region selection, and state.

For a new module or a material module change, follow the [Module Documentation Standard](../20-repository/module-documentation-standard.md) and [Add or Update an AWS Module](../30-deployment/add-or-update-module.md).

## 3. Make a focused change

Keep Terraform interfaces, tests, examples, and docs consistent. Preserve stable `for_each` keys and resource addresses unless replacement is intentional. Do not commit credentials, state files, state backups, or generated plan files.

## 4. Run safe local checks

From the repository root, run the relevant credential-free checks:

```powershell
terraform fmt -check -recursive
tflint --init
tflint --recursive --format compact
./scripts/Test-TerraformModules.ps1
terraform -chdir=examples/foundation init -backend=false -input=false
terraform -chdir=examples/foundation validate -no-color
```

The offline foundation plan is documented in the [Validation Summary](../70-validation/validation-summary.md). These checks use mocked providers or placeholder values; they do not prove AWS permissions, live service behavior, or cleanup.

## 5. Submit and follow through

Create a feature branch and pull request with the reason for the change, checks run, compatibility impact, and any cost or destructive implications. GitHub Actions performs pull request validation. The Azure DevOps pipeline runs on configured branch pushes and does not validate pull requests.

After merge, validation and optional GitHub/Azure DevOps publishing may run. Publishing creates or mirrors repository content; it does not deploy AWS resources. Consumers use their own reviewed deployment workflow and state. See the [Environment and Delivery Lifecycle](../30-deployment/environment-lifecycle.md) and [Operations Handbook](../50-operations/operations-handbook.md).
