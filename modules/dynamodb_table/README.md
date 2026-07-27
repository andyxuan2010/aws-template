# DynamoDB table module

Creates an encrypted DynamoDB table with on-demand billing, point-in-time
recovery, and deletion protection by default. Provisioned capacity, secondary
indexes, TTL, and streams are optional.

```hcl
module "sessions" {
  source = "../../modules/dynamodb_table"

  region_code = "use1"
  hash_key    = "session_id"
  attributes = {
    session_id = { type = "S" }
  }
  ttl_attribute_name = "expires_at"
}
```

Only key attributes belong in `attributes`; DynamoDB is schemaless for all other
fields. The module fails if key definitions and attribute declarations drift.
Production requires point-in-time recovery and deletion protection.
