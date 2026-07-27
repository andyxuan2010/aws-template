# S3 bucket module

AWS counterpart to the Azure template's `storageaccount` module. Secure defaults
enable encryption, versioning, S3 Object Ownership, all four public-access
blocks, and a policy denying requests that do not use TLS.

```hcl
module "logs" {
  source = "../../modules/s3_bucket"

  # Include an organization/account discriminator for global uniqueness.
  name        = "s3-acme-platform-use1-dev-001"
  region_code = "use1"
  kms_key_arn = module.kms.key_arn

  lifecycle_rules = {
    retention = {
      noncurrent_version_expiration   = 90
      abort_incomplete_multipart_days = 7
    }
  }
}
```

`force_destroy` defaults to false and is rejected in `prod`. A custom policy can
be supplied as JSON and is merged with the TLS enforcement statement. Optional
server access logging and Object Lock retention are supported. Object Lock is an
irreversible bucket capability and should be selected before initial creation.
MFA Delete is intentionally not exposed because normal automation roles cannot
reliably administer it; use a separately governed root-account procedure if the
control is required.
