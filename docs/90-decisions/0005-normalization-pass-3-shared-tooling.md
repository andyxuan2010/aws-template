# Normalization Pass 3: Shared Tooling

Date: 2026-10-30

## Scope

This pass audits and documents tooling that should behave consistently across the Azure, AWS, OCI, and GCP Terraform template repositories. It establishes the shared-tooling boundary before refactoring automation.

## Findings

- AWS and GCP have effectively duplicated `scripts/azure-pipelines/module-targets.sh` implementations.
- Both selectors read changed files and emit Azure Pipelines or JSON module matrices, but do not share a documented contract or Git-ref interface.
- AWS's module validation script stages modules and runs init, validate, and tests. Azure and OCI use PowerShell test runners with different options and failure checks.
- The selector currently classifies broad shared paths; the policy needs to be explicit and consistent before changing CI behavior.

## Shared contract

- Changed-module selection should use the same path classification and output semantics across the four repositories: module changes target that module; shared Terraform, scripts, pipeline, or module-catalog changes target all modules; unrelated documentation changes target none.
- The selector should support both Git base/head refs and a newline-delimited changed-file list, and emit newline, JSON-array, and CI matrix formats.
- CI must fail clearly when explicitly requested module names are unknown; an empty change set should produce an empty selection without being mistaken for successful test coverage.
- Validation entry points should preserve backend-free init, format, validate, asserted module tests, and standalone example validation.
- Provider-specific fixtures and cloud setup remain in each repository.

## Next implementation

1. Consolidate the duplicated AWS/GCP selector behind the shared contract.
2. Add the same selector interface to Azure and OCI.
3. Align runner failure semantics and CI invocation, then update each pipeline guide and decision record with the implemented behavior.

No infrastructure plan or apply is part of this tooling pass.
