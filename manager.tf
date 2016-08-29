resource "aws_instance" "manager" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "t2.micro"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = [
    "${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.availability-zone-public.id}"
  source_dest_check = false
  associate_public_ip_address = true
  tags {
    Name = "${var.pre_tag}-Manager-${var.post_tag}"
    Service = "${var.tag_service}"
    Environment = "${var.tag_environment}"
    Version = "${var.tag_version}"
  }
  connection {
    user = "centos"
  }

  /* Installing teraform in manager instance*/
  provisioner "remote-exec" {
    inline = [
      "curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo -E bash -",
      "curl https://releases.hashicorp.com/terraform/0.7.2/terraform_0.7.2_linux_amd64.zip > terraform_setup.zip",
      "sudo yum install -y git zip unzip nodejs",
      "sudo unzip terraform_setup.zip -d /home/centos/terraform/",
      "sudo rm terraform_setup.zip",
      "echo 'PATH=$PATH:$HOME/terraform' >> ~/.bashrc",
      "source ~/.bashrc && export PATH"
    ]
  }

  /*
  * Saving VPC, Subnet, Security Group and Nat gateway ID
  * into terraform.out file
  */
  provisioner "remote-exec" {
    inline = [
      "cat <<EOT >> terraform.out",
      "/* Generated outputs by Terraform */",
      "pre_tag = \"${var.pre_tag}\"",
      "post_tag = \"${var.post_tag}\"",
      "tag_service = \"${var.tag_service}\"",
      "tag_environment = \"${var.tag_environment}\"",
      "tag_version = \"${var.tag_version}\"",
      "aws_region = \"${var.aws_region}\"",
      "vpc_id = \"${aws_vpc.default.id}\"",
      "vpc_cidr = \"${aws_vpc.default.cidr_block}\"",
      "public_subnet_id = \"${aws_subnet.availability-zone-public.id}\"",
      "public_security_group_id = \"${aws_security_group.public.id}\"",
      "key_pair_name = \"${var.key_pair_name}\"",
      "EOT",
    ]
  }

}
