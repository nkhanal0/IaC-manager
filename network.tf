resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.pre_tag}-VPC-${var.post_tag}"
  }
}

resource "aws_subnet" "availability-zone-public" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.aws_region}a"
  tags {
    Name = "${var.pre_tag}-Public-Subnet-${var.post_tag}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "${var.pre_tag}-IGW-${var.post_tag}"
  }
}

resource "aws_route_table" "availability-zone-public" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
    Name = "${var.pre_tag}-Public-Subnet-${var.post_tag}"
  }
}

resource "aws_route_table_association" "availability-zone-public" {
  subnet_id = "${aws_subnet.availability-zone-public.id}"
  route_table_id = "${aws_route_table.availability-zone-public.id}"
}
