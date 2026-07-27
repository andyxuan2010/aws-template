# KMS key module

AWS counterpart to the encryption-key responsibilities of Azure Key Vault. It
creates a customer-managed KMS key, an optional conventional alias, and optional
grants. Rotation is enabled and the deletion waiting period is 30 days by
default.

```hcl
module "kms" {
  source = "../../modules/kms_key"

  workload    = "platform"
  region_code = "use1"
  environment = "dev"
}
```

Supply `key_policy_json` when organization policy requires explicit
administrators or service principals. Be careful not to create a policy that
prevents future key administration. The module rejects incompatible key
specification, usage, and rotation combinations, and production keys must retain
the 30-day deletion window. Multi-Region replicas should be managed by a
separate regional composition with an explicitly aliased AWS provider.
