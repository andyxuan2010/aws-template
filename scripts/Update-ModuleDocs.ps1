[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $repoRoot ".terraform-docs.yml"
$requiredFiles = @("README.md", "terraform.tf", "variables.tf", "locals.tf", "main.tf", "outputs.tf")

foreach ($module in Get-ChildItem -LiteralPath (Join-Path $repoRoot "modules") -Directory | Sort-Object Name) {
  foreach ($requiredFile in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $module.FullName $requiredFile))) {
      throw "$($module.Name) is missing required file $requiredFile"
    }
  }

  if (-not (Test-Path -LiteralPath (Join-Path $module.FullName "tests"))) {
    throw "$($module.Name) is missing its tests directory"
  }

  $readmePath = Join-Path $module.FullName "README.md"
  $readme = Get-Content -Raw -LiteralPath $readmePath

  if ($readme -notmatch "<!-- BEGIN_TF_DOCS -->") {
    $appendix = @"

## Prerequisites and Dependencies

Configure the AWS provider and credentials in the calling root module. Pass
dependencies through typed inputs and module outputs; this child module does
not configure providers or a backend.

## Important Behavior and Secure Defaults

Review the module defaults, lifecycle implications, replacement behavior, and
AWS service costs before use. Production guardrails fail during planning when
an unsafe combination can be detected statically.

## Naming and Tagging

Generated names and effective tags follow the repository
[naming convention](../../docs/NAMING_CONVENTION.md) and
[tagging standard](../../docs/TAGGING_STANDARD.md). Stable map keys are
Terraform resource identity and should not be renamed casually.

## Testing

```powershell
terraform init -backend=false
terraform validate
terraform test
```

Tests use mocked providers and do not apply AWS resources.

## Known Limitations

The module owns only the resources documented below. Account-level policies,
cross-account trust, service quotas, and live integration verification remain
the responsibility of the calling composition.

## Terraform Reference

The content below is generated from module source. Do not edit it manually.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
"@
    Set-Content -LiteralPath $readmePath -Value ($readme.TrimEnd() + $appendix + "`n")
  }

  terraform-docs --config $configPath $module.FullName
  if ($LASTEXITCODE -ne 0) {
    throw "terraform-docs failed for $($module.Name)"
  }

  $normalizedReadme = (Get-Content -Raw -LiteralPath $readmePath).TrimEnd()
  Set-Content -LiteralPath $readmePath -Value ($normalizedReadme + "`n") -NoNewline
}

Write-Host "Normalized documentation for all Terraform modules."
