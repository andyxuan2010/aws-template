# SQS queue module

Creates an encrypted standard or FIFO queue. SQS-managed encryption and
20-second long polling are enabled by default. A customer-managed KMS key and
resource policy can be supplied explicitly.

```hcl
module "orders" {
  source = "../../modules/sqs_queue"

  region_code = "use1"
  dead_letter_queue = {
    arn               = module.orders_dlq.queue_arn
    max_receive_count = 5
  }
}
```

Production queues require a dead-letter queue. Create the DLQ as a separate
module instance so its retention, consumers, and access policy remain explicit.
The module normalizes the `.fifo` suffix.
