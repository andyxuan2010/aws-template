# Resource Naming Convention

The AWS convention follows the Azure template's deterministic segment order:

```text
<resource-type>-<workload>-<region-code>-<environment>-<instance>
```

Example names:

```text
vpc-platform-use1-dev-001
secgrp-platform-use1-dev-001
s3-platform-use1-dev-001
iam-platform-dev-001
kms-platform-use1-dev-001
```

Global resources omit the region segment. Use lowercase letters, digits, and
hyphens. Use stable three-digit instance values. S3 bucket names must also be
globally unique, so callers should provide an organization or account-specific
prefix through `name` when the generated default is not unique enough.

The modules accept an explicit `name`. If omitted, they construct names from
`workload`, `region_code`, `environment`, and `instance`. AWS resources without a
native name field receive the generated value as their `Name` tag.

AWS reserves security-group names beginning with `sg-`, so that module uses
`secgrp-` instead of the otherwise preferred short resource prefix.
