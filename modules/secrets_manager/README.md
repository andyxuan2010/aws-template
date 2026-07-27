# Secrets Manager module

Creates secret metadata, optional replicas, an optional resource policy, and
optional Lambda-based rotation. It intentionally does not create a secret
version or accept secret values, because Terraform would persist those values
in state.

```hcl
module "database_secret" {
  source = "../../modules/secrets_manager"

  region_code = "use1"
  kms_key_id  = module.kms.key_arn

  rotation = {
    lambda_arn              = module.rotation.function_arn
    automatically_after_days = 30
  }
}
```

Populate the value through an approved out-of-band workflow or allow a service
such as RDS to own its generated credential. Production enforces the maximum
30-day deletion recovery window. Public resource policies are blocked by
default.
