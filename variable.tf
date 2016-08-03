variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_pair_name" {}
variable "pre_tag" {}
variable "post_tag" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
}

variable "amis" {
  description = "Centos AMIs by region"
  default = {
    ap-southeast-1 = "ami-f068a193"
    ap-northeast-1 = "ami-eec1c380"
  }
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default = "10.0.1.0/24"
}
