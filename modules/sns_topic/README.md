# SNS topic module

Creates an encrypted standard or FIFO SNS topic and optional subscriptions.
A customer-managed KMS key is required, signatures use version 2, and standard
topics enable active X-Ray tracing.

```hcl
module "events" {
  source = "../../modules/sns_topic"

  region_code      = "use1"
  kms_master_key_id = module.kms.key_arn
  subscriptions = {
    processing_queue = {
      protocol = "sqs"
      endpoint = module.processing_queue.queue_arn
    }
  }
}
```

Plaintext HTTP subscriptions are rejected unless explicitly allowed. Subscription
keys are Terraform identity and should remain stable. Queue, Lambda, and
Firehose destinations generally require a corresponding resource policy.
