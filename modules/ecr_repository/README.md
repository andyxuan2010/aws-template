# ECR repository module

Creates an encrypted ECR repository with immutable tags, scan-on-push, and a
default lifecycle policy. Untagged images expire after 14 days and the most
recent 50 tagged images are retained.

```hcl
module "repository" {
  source = "../../modules/ecr_repository"

  region_code    = "use1"
  encryption_type = "KMS"
  kms_key_arn     = module.kms.key_arn
}
```

Production rejects mutable tags, disabled scanning, and destructive
`force_delete`. Cross-account access must be granted through an explicit
repository policy.
