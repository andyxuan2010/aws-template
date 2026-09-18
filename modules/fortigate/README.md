# FortiGate module

Deploys FortiGate-VM on AWS using an approved or filtered AMI. The module
supports single-node and active-passive architectures, explicit multi-ENI
FortiOS port mapping, BYOL or PAYG licensing metadata, and FortiOS MIME
bootstrap user data. It owns EC2 instances and additional ENIs only; the
calling composition owns the VPC, subnets, security groups, IAM profile, AMI
approval, and Marketplace subscription.

## Minimum example

```hcl
module "fortigate" {
  source = "../../modules/fortigate"

  workload          = "edge"
  region_code       = "use1"
  ami_id            = "ami-0123456789abcdef0" # Approved FortiGate AMI.
  license_type      = "payg"
  security_group_ids = ["sg-0123456789abcdef0"]

  interfaces = {
    external = {
      role         = "external"
      primary      = true
      device_index = 0
      subnet_id    = "subnet-0123456789abcdef0"
    }
    internal = {
      role         = "internal"
      device_index = 1
      subnet_id    = "subnet-0123456789abcdef1"
    }
  }
}
```

## Active-passive example

Set `architecture = "active-passive"`. Supply `subnet_ids` for each interface
and static `private_ips` for the heartbeat interface, keyed by `a` and `b`.
The module generates the FortiOS `config system ha` stanza in each node's
user data, including unicast heartbeat peer addresses. Validate the selected
FortiOS version and interface naming with Fortinet before applying.

## Licensing and bootstrap

`license_type` records whether the selected AMI is BYOL or PAYG; it does not
subscribe an account to AWS Marketplace or validate Fortinet entitlement.
For BYOL, pass the license file through `bootstrap.license_file` only when
the state-handling implications are acceptable. The file is placed in the
FortiGate MIME user data format and therefore becomes part of Terraform state.
`bootstrap.config` accepts FortiOS CLI commands and is appended to generated
hostname and HA commands.

Public IP assignment is disabled by default and requires both
`associate_public_ip_address = true` and `allow_public_ip = true`; production
plans reject it. Use a controlled management path and narrowly scoped security
groups for administration.

## Dependencies and limitations

Configure the AWS provider and credentials in the root composition. The module
does not create routes, security groups, VPCs, EIPs, load balancers, IAM roles,
FortiManager integrations, or AWS Marketplace subscriptions. Additional ENIs
are created with source/destination checks disabled for firewall forwarding.
Changing interface keys or device indexes can replace or reattach networking;
review those changes as a topology migration.

## Testing

```powershell
terraform init -backend=false
terraform validate
terraform test
```

Tests use mocked providers and do not apply AWS resources.

## Terraform Reference

The content below is generated from module source. Do not edit it manually.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_attachment) | resource |
| [aws_ami.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_public_ip"></a> [allow\_public\_ip](#input\_allow\_public\_ip) | Explicit acknowledgement that a public IP is intended when associate\_public\_ip\_address is true. | `bool` | `false` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | Approved FortiGate AMI ID. Set this or image\_lookup, but not both. | `string` | `null` | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | FortiGate deployment architecture: single or active-passive. | `string` | `"single"` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate a public IPv4 address with the primary ENI. Disabled by default. | `bool` | `false` | no |
| <a name="input_bootstrap"></a> [bootstrap](#input\_bootstrap) | FortiOS cloud-init content. config is appended as CLI commands; license\_file is a BYOL license file and is stored in Terraform state when supplied. | <pre>object({<br>    config           = optional(string, "")<br>    license_file     = optional(string, "")<br>    include_hostname = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | Enable EC2 API termination protection. | `bool` | `true` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | Enable EBS optimization when supported by the selected instance type. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_ha"></a> [ha](#input\_ha) | Generated active-passive HA settings. Used only when architecture is active-passive. | <pre>object({<br>    group_id            = optional(number, 1)<br>    group_name          = optional(string, "fortigate-ha")<br>    heartbeat_interface = optional(string, "ha")<br>    heartbeat_priority  = optional(number, 100)<br>    primary_priority    = optional(number, 200)<br>    secondary_priority  = optional(number, 100)<br>    session_pickup      = optional(bool, true)<br>    unicast_hb          = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | Optional IAM instance profile name attached to each FortiGate instance. | `string` | `null` | no |
| <a name="input_image_lookup"></a> [image\_lookup](#input\_image\_lookup) | Optional region-local AMI lookup. Use an explicit ami\_id for approved production image pinning. | <pre>object({<br>    owners      = list(string)<br>    most_recent = optional(bool, false)<br>    filters     = map(list(string))<br>  })</pre> | `null` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags supplied by the root composition. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type supported by the selected FortiGate version and model. | `string` | `"c5.xlarge"` | no |
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | FortiGate interfaces keyed by logical name. Use device\_index to preserve the intended FortiOS port mapping; active-passive nodes use subnet\_ids and private\_ips keyed by a and b. | <pre>map(object({<br>    role                  = string<br>    subnet_id             = optional(string, "")<br>    subnet_ids            = optional(map(string), {})<br>    primary               = optional(bool, false)<br>    device_index          = number<br>    private_ip            = optional(string)<br>    private_ips           = optional(map(string), {})<br>    security_group_ids    = optional(set(string), [])<br>    enabled_architectures = optional(set(string), ["single", "active-passive"])<br>  }))</pre> | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Optional EC2 key pair name for emergency operating-system access. | `string` | `null` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | FortiGate licensing model represented by the selected AMI: byol or payg. Marketplace subscription and entitlements remain caller responsibilities. | `string` | `"byol"` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | EC2 Instance Metadata Service controls. IMDSv2 is required by default. | <pre>object({<br>    http_endpoint               = optional(string, "enabled")<br>    http_tokens                 = optional(string, "required")<br>    http_put_response_hop_limit = optional(number, 1)<br>    instance_metadata_tags      = optional(string, "disabled")<br>  })</pre> | `{}` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Enable EC2 detailed monitoring. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit FortiGate name prefix. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code, for example use1. | `string` | n/a | yes |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Encrypted root EBS volume configuration. | <pre>object({<br>    volume_type           = optional(string, "gp3")<br>    volume_size           = optional(number, 20)<br>    iops                  = optional(number)<br>    throughput            = optional(number)<br>    encrypted             = optional(bool, true)<br>    kms_key_id            = optional(string)<br>    delete_on_termination = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Default security groups for interfaces that do not specify a per-interface override. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | Replace the instance when generated or supplied bootstrap content changes. | `bool` | `true` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier used in the generated name. | `string` | `"network"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | AMI ID used by the FortiGate instances. |
| <a name="output_architecture"></a> [architecture](#output\_architecture) | Effective FortiGate architecture. |
| <a name="output_bootstrap_applied"></a> [bootstrap\_applied](#output\_bootstrap\_applied) | Whether FortiOS user data was generated for the instances. |
| <a name="output_instance_arns"></a> [instance\_arns](#output\_instance\_arns) | FortiGate EC2 instance ARNs keyed by node suffix. |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | FortiGate EC2 instance IDs keyed by node suffix. |
| <a name="output_instance_private_ips"></a> [instance\_private\_ips](#output\_instance\_private\_ips) | Primary private IP addresses keyed by node suffix. |
| <a name="output_instance_public_ips"></a> [instance\_public\_ips](#output\_instance\_public\_ips) | Primary public IP addresses keyed by node suffix, when public IP assignment is explicitly enabled. |
| <a name="output_interface_order"></a> [interface\_order](#output\_interface\_order) | Effective interface order by logical interface name. Device indexes remain authoritative for FortiOS port mapping. |
| <a name="output_name"></a> [name](#output\_name) | Resolved FortiGate resource name prefix. |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | Additional ENI IDs keyed by <node>-<interface>; primary ENI IDs are exposed separately. |
| <a name="output_network_interface_private_ips"></a> [network\_interface\_private\_ips](#output\_network\_interface\_private\_ips) | Additional ENI primary private IP addresses keyed by <node>-<interface>; use the FortiGate traffic-interface IPs as GWLB targets. |
| <a name="output_primary_network_interface_ids"></a> [primary\_network\_interface\_ids](#output\_primary\_network\_interface\_ids) | Primary ENI IDs keyed by node suffix. |
<!-- END_TF_DOCS -->
