provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "main" {
    cidr_block = "172.16.0.0/16"
}

data "aws_availability_zones"  "all" {}

resource "aws_subnet" "private" {
  vpc_id                = aws_vpc.main.id
  cidr_block            = "172.16.1.0/24"
  availability_zone     = data.aws_availability_zones.all.names[0]

  tags = {
        Name = "terraform-private-sn"
  }
}

resource "aws_subnet" "private_two" {
    vpc_id = aws_vpc.main.id
    cidr_block = "172.16.2.0/24"
    availability_zone = data.aws_availability_zones.all.names[1]
    
    tags = {
        Name = "terraform-private-two-sn"
    }
}

data "aws_subnets" "subnet_ids" {
    filter {
        name = "vpc-id"
        values = [aws_vpc.main.id]
    }
}

output "zones" {
    value = data.aws_availability_zones.all
}

output "subnet_stuff" {
    value = data.aws_subnets.subnet_ids
}