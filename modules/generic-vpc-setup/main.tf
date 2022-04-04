resource "aws_vpc" "main" {
    cidr_block          = var.cidr_block
    enable_dns_hostnames = true


    tags = {
        Name = var.vpc_name
    }
}

data "aws_vpc" "vpc-attributes" {
    id = aws_vpc.main.id
}

data "aws_availability_zones" "all" {}

resource "aws_subnet" "public" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.public_sn_cidr_block
  availability_zone    = data.aws_availability_zones.all.names[0]

  map_public_ip_on_launch = true

  tags = {
        Name = "terraform-public-sn"
  }
}

resource "aws_subnet" "private" {
  vpc_id                = aws_vpc.main.id
  cidr_block            = var.private_sn_cidr_block
  availability_zone    = data.aws_availability_zones.all.names[1]

  tags = {
        Name = "terraform-private-sn"
  }  
}

resource "aws_subnet" "private-two" {
  vpc_id                = aws_vpc.main.id
  cidr_block            = var.private_sn_cidr_block_2
  availability_zone    = data.aws_availability_zones.all.names[2]

  tags = {
        Name = "terraform-private-sn"
  }  
}

resource "aws_internet_gateway" "main" {
    vpc_id              = aws_vpc.main.id

    tags = {
        Name = "terraform-main"
    }
}

resource "aws_route_table" "public" {
    vpc_id              = aws_vpc.main.id

    route {
        cidr_block      = "0.0.0.0/0"
        gateway_id      = aws_internet_gateway.main.id
    }

    tags = {
        Name = "terraform-public-rt"
    }
}

resource "aws_route_table" "private" {
    vpc_id              = aws_vpc.main.id

    tags = {
        Name = "terraform-private-rt"
    }
}

resource "aws_route_table" "private2" {
    vpc_id              = aws_vpc.main.id

    tags = {
        Name = "terraform-private-rt"
    }
}

resource "aws_route_table_association" "public-assc1" {
    subnet_id           = aws_subnet.public.id
    route_table_id      = aws_route_table.public.id
}

resource "aws_route_table_association" "private-assc2" {
    subnet_id           = aws_subnet.private.id
    route_table_id      = aws_route_table.private.id
}

resource "aws_route_table_association" "private-assc3" {
    subnet_id           = aws_subnet.private-two.id
    route_table_id      = aws_route_table.private2.id
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] 

}

resource "aws_instance" "public" {
    ami                 = data.aws_ami.ubuntu.id
    instance_type       = "t2.micro"

    key_name = "terraform-key-pair"

    subnet_id           = aws_subnet.public.id
    vpc_security_group_ids = [ aws_security_group.allow_ssh_and_ping.id ]

    tags = {
        Name = "Public EC2 tgtv"
    }
}

resource "aws_instance" "private" {
    ami                 = data.aws_ami.ubuntu.id
    instance_type       = "t2.micro"

    key_name = "terraform-key-pair"

    subnet_id           = aws_subnet.private.id
    vpc_security_group_ids = [ aws_security_group.allow_ssh_and_ping.id ]

    tags = {
        Name = "Private EC2 tgtv"
    }
}

