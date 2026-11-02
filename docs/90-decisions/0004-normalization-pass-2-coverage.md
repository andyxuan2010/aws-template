# Normalization Pass 2: Coverage

Date: 2026-10-30

Pass 2 adds the missing AWS module coverage and gives every module a standalone example.

## Changes

- Added mocked plan suites to `autoscaling`, `cloudfront`, `efs`, `eks`, `elasticache`, and `security_hub_cspm`.
- Assertions cover instance metadata and capacity, CloudFront HTTPS and private S3 origin signing, encrypted multi-AZ EFS, private/encrypted EKS, encrypted/failover ElastiCache, and explicit Security Hub standards and aggregation.
- Added one standalone root example under `modules/<module>/examples/basic` for each of the 37 modules, using representative values from the module test suite.
- Example README files explain that placeholder identifiers must be replaced before planning or applying.
- Both GitHub Actions and Azure Pipelines validate the changed module's standalone example with backend-free initialization.

## Validation

- Terraform formatting passed, and the six new module test suites passed locally. The GitHub and Azure pipeline matrices run the test and standalone example checks for changed modules.
- All 37 standalone examples passed together through backend-free initialization and Terraform validation. No apply is part of this coverage pass.
