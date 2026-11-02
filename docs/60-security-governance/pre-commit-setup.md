# Pre-commit Setup

The repository includes local hooks for Terraform formatting and mocked module
validation in `.pre-commit-config.yaml`.

## Requirements

- Git and Python with the `pre-commit` package installed.
- Terraform installed and available on `PATH`.
- PowerShell available for the repository's module-validation hook.

Install the hooks from the repository root:

```powershell
python -m pip install pre-commit
pre-commit install
```

Run all configured hooks against the current checkout with:

```powershell
pre-commit run --all-files
```

The hooks run `terraform fmt -check -recursive` and
`scripts/Test-TerraformModules.ps1`. They do not authenticate to AWS or create
resources. CI remains the required shared validation source; local hooks help
catch issues before a push.
