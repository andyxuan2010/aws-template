# S3 bucket Architecture

```mermaid
flowchart LR
  Caller["Calling root module"] --> Module["s3_bucket module"]
  Module --> R1["aws_s3_bucket"]
  Module --> R2["aws_s3_bucket_ownership_controls"]
  Module --> R3["aws_s3_bucket_public_access_block"]
  Module --> R4["aws_s3_bucket_versioning"]
  Module --> R5["aws_s3_bucket_server_side_encryption_configuration"]
  Module --> R6["aws_s3_bucket_lifecycle_configuration"]
  Module --> R7["aws_s3_bucket_logging"]
  Module --> R8["aws_s3_bucket_object_lock_configuration"]
  Module --> R9["aws_s3_bucket_policy"]
```

The s3_bucket module declares 9 managed resource type(s), including `aws_s3_bucket`, `aws_s3_bucket_ownership_controls`, `aws_s3_bucket_public_access_block`, `aws_s3_bucket_versioning`, `aws_s3_bucket_server_side_encryption_configuration`, `aws_s3_bucket_lifecycle_configuration`, `aws_s3_bucket_logging`, `aws_s3_bucket_object_lock_configuration`, `aws_s3_bucket_policy`.

Resources that use `count` or `for_each` are gated by inputs such as `lifecycle_rules`, `access_logging`, `object_lock`, `enforce_tls`, `bucket_policy_json`. Review those inputs to see which optional components a deployment creates.

The module accepts 21 input(s), with 1 required.
It returns 6 output(s), including `bucket_id`, `bucket_arn`, `bucket_domain_name`, `bucket_regional_domain_name`, `name`, `object_lock_enabled`. Pass these to downstream modules instead of recreating the resources in the caller.

The caller owns the surrounding infrastructure, such as the resource group, networks, identities, and key or log destinations that this module references. See the [module README](../README.md) for inputs and usage.
