output "public_security_group_id" {
  value = "${aws_security_group.public.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.availability-zone-public.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}