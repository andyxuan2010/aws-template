# Foundation composition example

This example composes all five modules into a two-Availability-Zone network with
public and private subnets, restricted workload ingress, KMS-encrypted S3
storage, and an EC2-trusted IAM role.

Copy the example to an environment root, configure a remote backend, and supply
a globally unique bucket name:

```powershell
terraform init
terraform plan -var="bucket_name=s3-yourorg-platform-use1-dev-001"
```

The example uses `nat_gateway_mode = "per_az"` and creates two NAT gateways,
which incur AWS charges. Use `single` or `none` for sandboxes where resilient
outbound internet access is not required.
