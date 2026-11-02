# Add or Update an AWS Module

Use this workflow when introducing a capability or changing a module's public
interface. Keep the module reusable, testable without AWS credentials, and
clear about what its caller owns.

## Implementation steps

1. Check the [Modules Index](../20-repository/modules-index.md) and
   [Module Usage and Dependencies](../20-repository/module-usage-and-dependencies.md)
   to identify overlaps and existing composition contracts.
2. Define resource ownership, required caller inputs, stable `for_each` keys,
   secure defaults, and replacement-sensitive changes before editing Terraform.
3. Add or update typed variables, validations, resources, outputs, and
   `terraform.tf`. Do not add provider or backend configuration to a child
   module.
4. Add mocked `.tftest.hcl` coverage for the default path, optional behavior,
   and unsafe combinations. Tests must not create AWS resources.
5. Update the module README using the
   [documentation standard](../20-repository/module-documentation-standard.md),
   including generated Terraform reference content.
6. Update the [Modules Index](../20-repository/modules-index.md), usage guide,
   and architecture docs when the module adds a cross-module contract.
7. Run the formatting, lint, module test, and offline foundation checks listed
   in the [Validation Summary](../70-validation/validation-summary.md).
8. Review the GitHub Actions result and the Azure DevOps push build before
   publishing a module change to downstream repositories.

## Breaking changes

Treat changes to variable names or types, map keys, defaults, resource
addresses, and deletion behavior as interface or lifecycle changes. Document
the migration path and whether callers may need `moved` blocks, imports, or a
planned replacement. Do not claim compatibility based only on a successful
mocked plan.
