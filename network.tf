provider "aws" {
  region = "${var.AWS_DEFAULT_REGION}"
}
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.pre_tag}-VPC-${var.post_tag}"
    Service = "${var.tag_service}"
    Environment = "${var.tag_environment}"
    Version = "${var.tag_version}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "management_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.management_subnet_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "${var.pre_tag}-Management-${var.post_tag}"
    Service = "${var.tag_service}"
    Environment = "${var.tag_environment}"
    Version = "${var.tag_version}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "${var.pre_tag}-IGW-${var.post_tag}"
    Service = "${var.tag_service}"
    Environment = "${var.tag_environment}"
    Version = "${var.tag_version}"
  }
}

resource "aws_route_table" "management_route_table" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }
  tags {
    Name = "${var.pre_tag}-Management-${var.post_tag}"
    Service = "${var.tag_service}"
    Environment = "${var.tag_environment}"
    Version = "${var.tag_version}"
  }
}

resource "aws_route_table_association" "management" {
  subnet_id = "${aws_subnet.management_subnet.id}"
  route_table_id = "${aws_route_table.management_route_table.id}"
}
