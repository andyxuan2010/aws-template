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
ec2-platform-use1-dev-001
alb-platform-use1-dev-001
rds-platform-use1-dev-001
lambda-platform-use1-dev-001
secret-platform-use1-dev-001
ecr-platform-use1-dev-001
ecs-platform-use1-dev-001
ddb-platform-use1-dev-001
sqs-platform-use1-dev-001
sns-platform-use1-dev-001
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

Service length limits take precedence over the full shape. ALB and target-group
names are deterministically truncated to 32 characters, while Lambda names are
truncated to 64 characters. Keep `workload` codes short enough that environment
and instance segments remain visible.

FIFO queue and topic modules normalize the required `.fifo` suffix. Callers may
provide names with or without it, but toggling FIFO mode is a replacement.
