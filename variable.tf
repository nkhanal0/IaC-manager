variable "key_pair_name" {
  description = "The key-pair name created with AWS"
}
variable "pre_tag" {
  description = "Pre Tag for all the resources"
}
variable "post_tag" {
  description = "Post Tag for all the resources"
}
variable "tag_service" {
  description = "Service tag"
}
variable "tag_environment" {
  description = "Environment tag"
}
variable "tag_version" {
  description = "Version tag"
}
variable "amis" {
  description = "CentOS AMIs by region"
  default = {
    ap-southeast-1 = "ami-f068a193"
    ap-northeast-1 = "ami-eec1c380"
    ap-south-1 = "ami-95cda6fa"
    us-east-1 = "ami-6d1c2007"
    us-west-1 = "ami-af4333cf"
    us-west-2 = "ami-d2c924b2"
  }
}
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}
variable "management_subnet_cidr" {
  description = "CIDR for the Management Subnet"
  default = "10.0.0.0/24"
}
variable "AWS_DEFAULT_REGION" {}
