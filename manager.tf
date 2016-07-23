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

resource "aws_security_group" "public" {
  name = "${var.pre_tag}-Mesos-Security-Public-${var.post_tag}"
  description = "Allow incoming HTTP connections."
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "${var.pre_tag}-Public-SG-${var.post_tag}"
  }
}

resource "aws_instance" "manager" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.availability-zone-public.id}"
  source_dest_check = false
  associate_public_ip_address = true
  tags {
    Name = "${var.pre_tag}-Manager-${var.post_tag}"
  }
  connection {
    user = "centos"
    private_key = "${file(var.aws_key_path)}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "curl https://releases.hashicorp.com/terraform/0.6.16/terraform_0.6.16_linux_amd64.zip > terraform_setup.zip",
      "sudo yum -y install unzip",
      "sudo unzip terraform_setup.zip -d /home/centos/terraform/",
      "sudo rm terraform_setup.zip",
      "echo 'PATH=$PATH:$HOME/terraform' >> ~/.bashrc",
      "source ~/.bashrc && export PATH",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "echo '/* Generated outputs by Terraform */' >> ~/terraform.out",
      "echo 'public_security_group_id = \"${aws_security_group.public.id}\"' >> ~/terraform.out",
      "echo 'public_subnet_id = \"${aws_subnet.availability-zone-public.id}\"' >> ~/terraform.out",
      "echo 'vpc_id = \"${aws_vpc.default.id}\"' >> ~/terraform.out",
      "echo 'aws_key_path = \"${var.aws_key_path}\"' >> ~/terraform.out",
      "printf 'aws_key_name = \"${var.aws_key_name}\"' >> ~/terraform.out"
    ]
  }
  provisioner "file" {
    source = "${var.aws_key_path}"
    destination = "~/${replace(var.aws_key_path,\"./" , "")}"
  }
}