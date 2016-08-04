variable "key_pair_name" {
  description = "The key-pair name created with AWS"
}
variable "pre_tag" {
  description = "Pre Tag for all the resources"
}
variable "post_tag" {
  description = "Post Tag for all the resources"
}
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
