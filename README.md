### IaC: Manager Node (Jump Server)
This terraform script will setup an infrastructure for management in AWS and will create following resources:
 - Manager Node (CentOS)
 - VPC
 - Management subnet
 - Internet gateway
 - An IAM role attached to the Manager node which has the following access.
 	- ec2
 	- elasticloadbalancing
 	- cloudwatch
 	- autoscaling
 	- lambda
 	- logs
 	- s3
 	- elasticache
 	- ecr
 	- route53
 	- route53domains
 	- apigateway
 	- es
 	- iam
 	- events

#### Pre-requisites
- An IAM account with the following access:
	- AmazonEC2FullAccess
	- IAMFullAccess
	- AmazonVPCFullAccess
	
- Install [terraform](https://www.terraform.io/intro/getting-started/install.html) on your machine.
- Public Key Access with Agent support/ Agent Forwarding:

  ```bash
  ssh-add <key_pair_name>.pem
  ```

#### Steps for installation
- Clone this repo.
- `cp terraform.dummy terraform.tfvars`
- Modify params in `terraform.tfvars`
- Modify params in `variable.tf` to change subnet or add AMI accordingly to your aws region
- Export AWS credentials as bash variables (e.g. `ap-northeast-1` for Tokyo and `ap-southeast-1` for Singapore region):
```bash
export AWS_ACCESS_KEY_ID="anaccesskey" 
export AWS_SECRET_ACCESS_KEY="asecretkey"
export TF_VAR_AWS_DEFAULT_REGION="ap-northeast-1"
```
- Run `terraform plan` to see the plan to execute.
- Run `terraform apply` to run the scripts.
- You may have `prod/dev/stage` configurations in
`terraform.tfvars.{prod/dev/stage}` files (already ignored by `.gitignore`).

#### Test
  ```bash
  ssh -A centos@<manager_public_ip>
  ```
  
#### Generate Terraform documentation 
* Install [terraform-docs](https://github.com/segmentio/terraform-docs)
* `bash generate-docs.sh`

#### Notes
- SSH into the manager node and check whether `terraform.out` in `home/centos` contains:
a record of the VPC, Subnet, Security Group and Nat gateway ID.
- More details on [terraform-docs](https://github.com/segmentio/terraform-docs).
- If unable to perform `terraform destroy`, instance profile can only be removed using aws cli.
`aws iam list-instance-profiles | grep InstanceProfileName`
`delete-instance-profile --instance-profile-name ${var.pre_tag}_manager_${var.post_tag}`

#### Contributing

1. Make a feature branch: __git checkout -b your-username/your-feature__
2. Follow Terraform Style Guide
3. Make your feature. Keep things tidy so you have one commit per self-contained change (squashing can help).
4. Push your branch: __git push -u origin your-username/your-feature__
5. Open GitHub to the repo,
   under "Your recently pushed branches", click __Pull Request__ for
   _your-username/your-feature_.

Be sure to use a separate feature branch and pull request for every
self-contained feature.  If you need to make changes from feedback, make
the changes in place rather than layering on commits (use interactive
rebase to edit your earlier commits).  Then use __git push --force
origin your-feature__ to update your pull request.

