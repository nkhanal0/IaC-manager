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

  /* Installing teraform in manager instance*/
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

  /*
  * Saving VPC, Subnet, Security Group and Nat gateway ID
  * into terraform.out file
  */
  provisioner "remote-exec" {
    inline = [
      "echo '/* Generated outputs by Terraform */' >> ~/terraform.out",
      "echo 'public_security_group_id = \"${aws_security_group.public.id}\"' >> ~/terraform.out",
      "echo 'public_subnet_id = \"${aws_subnet.availability-zone-public.id}\"' >> ~/terraform.out",
      "echo 'vpc_id = \"${aws_vpc.default.id}\"' >> ~/terraform.out",
      "echo 'aws_key_path = \"${var.aws_key_path}\"' >> ~/terraform.out",
      "echo 'aws_key_name = \"${var.aws_key_name}\"' >> ~/terraform.out"
    ]
  }

  /* Copy the ssh key to manager node*/
  provisioner "file" {
    source = "${var.aws_key_path}"
    destination = "~/${replace(var.aws_key_path,\"./" , "")}"
  }
}