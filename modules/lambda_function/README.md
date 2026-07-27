# Lambda function module

Creates a Lambda function from exactly one local ZIP, S3 ZIP, or container image
source. The execution role remains external so IAM policy ownership stays
explicit.

Secure defaults publish immutable versions, enable active X-Ray tracing, prefer
ARM64, and avoid environment variables unless supplied. Do not place secrets in
`environment_variables`; retrieve Secrets Manager values at runtime.

```hcl
module "processor" {
  source = "../../modules/lambda_function"

  region_code = "use1"
  role_arn    = module.lambda_role.role_arn
  filename    = "build/processor.zip"
  runtime     = "python3.13"
  handler     = "handler.main"
  source_code_hash = filebase64sha256("build/processor.zip")
}
```

Use `code_signing_config_arn` for organizations that require signed ZIP
artifacts. Add a dead-letter destination for asynchronous production workloads.
