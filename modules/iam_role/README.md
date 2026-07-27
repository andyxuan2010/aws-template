# IAM role module

AWS counterpart to the Azure template's `managedidentity` and
`roleassignments` modules. It creates a role from an explicit trust policy,
attaches managed and inline policies, supports a permissions boundary, and can
create an EC2 instance profile.

```hcl
module "ec2_role" {
  source = "../../modules/iam_role"

  workload               = "platform"
  environment            = "dev"
  create_instance_profile = true
  trust_policy_statements = [{
    actions = ["sts:AssumeRole"]
    principals = [{
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }]
  }]
}
```

The typed trust-policy interface is preferred because it makes principals,
actions, and conditions reviewable. Raw JSON remains an advanced, mutually
exclusive escape hatch. The module does not invent trust relationships or
permissions. Root compositions must make both explicit and should use a
permissions boundary in multi-account landing zones.
