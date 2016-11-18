output "manager_public_ip" {
  value = "${aws_instance.manager.public_ip}"
}

output "key_pair_name" {
  value = "${var.key_pair_name}"
}

