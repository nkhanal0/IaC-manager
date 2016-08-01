
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
| public_subnet_cidr | CIDR for the Public Subnet | `"10.0.0.0/24"` | no |
| private_subnet_cidr | CIDR for the Private Subnet | `"10.0.1.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| public_security_group_id |  |
| public_subnet_id |  |
| vpc_id |  |

