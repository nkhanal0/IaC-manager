
## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| aws_access_key |  | - | yes |
| aws_secret_key |  | - | yes |
| key_pair_name |  | - | yes |
| pre_tag |  | - | yes |
| post_tag |  | - | yes |
| aws_region | EC2 Region for the VPC | - | yes |
| amis | Centos AMIs by region | `<map>` | no |
| vpc_cidr | CIDR for the whole VPC | `"10.0.0.0/16"` | no |
| management_subnet_cidr | CIDR for the Management Subnet | `"10.0.0.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| management_security_group_id |  |
| management_subnet_id |  |
| vpc_id |  |

