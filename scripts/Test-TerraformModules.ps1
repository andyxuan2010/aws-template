[CmdletBinding()]
param(
  [Parameter()]
  [string[]]$Module
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$modulePaths = Get-ChildItem -LiteralPath (Join-Path $repoRoot "modules") -Directory

if ($Module.Count -gt 0) {
  $requestedModules = [System.Collections.Generic.HashSet[string]]::new(
    [string[]]$Module,
    [System.StringComparer]::OrdinalIgnoreCase
  )
  $modulePaths = @($modulePaths | Where-Object { $requestedModules.Contains($_.Name) })
  $foundModules = @($modulePaths | ForEach-Object Name)
  $missingModules = @($Module | Where-Object { $_ -notin $foundModules })
  if ($missingModules.Count -gt 0) {
    throw "Unknown module(s): $($missingModules -join ', ')"
  }
}

$failed = @()
$validationRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ccoe-aws-terraform-validation-" + [guid]::NewGuid().ToString("N"))
$pluginCache = Join-Path ([System.IO.Path]::GetTempPath()) "ccoe-terraform-plugin-cache"

New-Item -ItemType Directory -Path $validationRoot | Out-Null
New-Item -ItemType Directory -Force -Path $pluginCache | Out-Null
$env:TF_PLUGIN_CACHE_DIR = $pluginCache
$env:TF_PLUGIN_TIMEOUT = "120s"

try {
  foreach ($modulePath in $modulePaths) {
    Write-Host "Validating $($modulePath.Name)..."
    $stagedModule = Join-Path $validationRoot $modulePath.Name
    New-Item -ItemType Directory -Path $stagedModule | Out-Null

    Get-ChildItem -LiteralPath $modulePath.FullName -File |
      Where-Object { $_.Name -ne ".terraform.lock.hcl" } |
      Copy-Item -Destination $stagedModule

    $sourceTests = Join-Path $modulePath.FullName "tests"
    if (Test-Path -LiteralPath $sourceTests) {
      Copy-Item -LiteralPath $sourceTests -Destination $stagedModule -Recurse
    }

    Push-Location $stagedModule
    try {
      terraform init -backend=false -input=false -no-color | Out-Null
      if ($LASTEXITCODE -ne 0) { throw "terraform init failed" }
      terraform validate -no-color
      if ($LASTEXITCODE -ne 0) { throw "terraform validate failed" }
      terraform test -no-color
      if ($LASTEXITCODE -ne 0) { throw "terraform test failed" }
    }
    catch {
      $failed += $modulePath.Name
      Write-Error -ErrorAction Continue "$($modulePath.Name): $_"
    }
    finally {
      Pop-Location
    }
  }
}
finally {
  $resolvedValidationRoot = [System.IO.Path]::GetFullPath($validationRoot)
  $resolvedTempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
  if ($resolvedValidationRoot.StartsWith($resolvedTempRoot) -and (Split-Path -Leaf $resolvedValidationRoot).StartsWith("ccoe-aws-terraform-validation-")) {
    Remove-Item -LiteralPath $resolvedValidationRoot -Recurse -Force
  }
}

if ($failed.Count -gt 0) {
  throw "Validation failed for: $($failed -join ', ')"
}

Write-Host "All Terraform modules passed validation and tests."
