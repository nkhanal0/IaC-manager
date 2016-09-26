output "manager_public_ip" {
  value = "${aws_instance.manager.public_ip}"
}

output "key_pair_name" {
  value = "${var.key_pair_name}"
}

output "public_security_group_id" {
  value = "${aws_security_group.public.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.availability-zone-public.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "public_route_table_id" {
  value = "${aws_route_table.availability-zone-public.id}"
}
