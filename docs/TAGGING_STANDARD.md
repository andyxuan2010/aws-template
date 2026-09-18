# Tagging Standard

Root compositions own enterprise tag normalization. Reusable modules consume
the canonical baseline through `inherited_tags` and merge resource-specific
`tags` over it:

```hcl
tags = merge(var.inherited_tags, var.tags)
```

The root should normally provide keys such as `Application`, `Environment`,
`Owner`, `CostCenter`, `DataClassification`, and `ManagedBy`. Modules add only a
`Name` tag where the resource supports tags. Caller-provided resource tags take
precedence over inherited tags; the generated `Name` tag takes precedence for
consistent resource identity.

AWS provider `default_tags` may supply organization-wide tags, but explicit
`inherited_tags` keeps module behavior visible and testable in plans.
