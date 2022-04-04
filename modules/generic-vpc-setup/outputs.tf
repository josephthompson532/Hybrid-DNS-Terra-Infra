output "az_zones" {
    description = "stuff"
    value = data.aws_availability_zones.all.names
}

output "vpc-id" {
    value = aws_vpc.main.id
}

output "private-subnet-id-one" {
    value = aws_subnet.private.id
}

output "private-subnet-id-two" {
    value = aws_subnet.private-two.id
}

output "public-subnet-id" {
    value = aws_subnet.public.id
}

output "vpc-cidr-range" {
    value = data.aws_vpc.vpc-attributes.cidr_block
}

output "public-subnet-route-table-id" {
    value = aws_route_table.public.id
}

output "private-subnet-route-table-id" {
    value = aws_route_table.private.id
}

output "private-instance-private-ip" {
    value = aws_instance.private.private_ip
}

output "public-instance-private-ip" {
    value = aws_instance.public.private_ip
}

output "public-instance-public-ip" {
    value = aws_instance.public.public_ip
}

output "security-group-id" {
    value = aws_security_group.allow_ssh_and_ping.id
}