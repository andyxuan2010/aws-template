# application_load_balancer basic example

This standalone root configuration calls `modules/application_load_balancer` with the representative inputs used by its mocked module test. Identifier values are illustrative. Replace them with real values from your account before planning or applying.

The internal ALB forwards HTTPS traffic on port 443. Replace `certificate_arn` with
an issued ACM certificate in `us-east-1` for the hostname clients will use.

From this directory, run `terraform init -backend=false` and `terraform validate`. Run `terraform plan` only after configuring provider credentials and replacing all illustrative identifiers with valid resources for your cloud account.
