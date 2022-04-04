provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "main" {
    cidr_block          = "172.17.0.0/16"

    tags = {
        Name = "terraform-vpc"
    }
}

resource "aws_subnet" "public" {
  vpc_id                = aws_vpc.main.id
  cidr_block            = "172.17.1.0/24"

  tags = {
        Name = "terraform-public-sn"
  }
}

resource "aws_subnet" "private" {
  vpc_id                = aws_vpc.main.id
  cidr_block            = "172.17.2.0/24"

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

    route {
        cidr_block      = "172.16.0.0/16"
    }

    tags = {
        Name = "terraform-private-rt"
    }
}

resource "aws_route_table_association" "public-assc" {
    subnet_id           = aws_subnet.public.id
    route_table_id      = aws_route_table.public.id
}

resource "aws_route_table_association" "private-assc" {
    subnet_id           = aws_subnet.private.id
    route_table_id      = aws_route_table.public.id
}

resource "aws_instance" "public" {
    ami                 = "ami-0069d66985b09d219"
    instance_type       = "t2.micro"

    subnet_id           = aws_subnet.public.id

    tags = {
        Name = "HelloWorld"
    }
}

resource "aws_instance" "private" {
    ami                 = "ami-0069d66985b09d219"
    instance_type       = "t2.micro"

    subnet_id           = aws_subnet.private.id

    tags = {
        Name = "HelloWorld"
    }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}