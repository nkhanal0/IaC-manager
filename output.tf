output "manager_public_ip" {
  value = "${aws_instance.manager.public_ip}"
}

output "key_pair_name" {
  value = "${var.key_pair_name}"
}

output "management_security_group_id" {
  value = "${aws_security_group.management.id}"
}

output "management_subnet_id" {
  value = "${aws_subnet.management_subnet.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "management_route_table_id" {
  value = "${aws_route_table.management_route_table.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.internet_gateway.id}"
}
