resource "aws_vpc" "main" {
    cidr_block          = var.cidr_block

    tags = {
        Name = "terraform-vpc"
    }
}

resource "aws_subnet" "public" {
  vpc_id                = aws_vpc.main.id
  cidr_block            = var.public_sn_cidr_block

  tags = {
        Name = "terraform-public-sn"
  }
}

resource "aws_subnet" "private" {
  vpc_id                = aws_vpc.main.id
  cidr_block            = var.private_sn_cidr_block

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

resource "aws_route_table_association" "public-assc" {
    subnet_id           = aws_subnet.public.id
    route_table_id      = aws_route_table.public.id
}

resource "aws_route_table_association" "private-assc" {
    subnet_id           = aws_subnet.private.id
    route_table_id      = aws_route_table.public.id
}

resource "aws_instance" "public" {
    ami                 = "ami-064ff912f78e3e561"
    instance_type       = "t2.micro"

    subnet_id           = aws_subnet.public.id

    tags = {
        Name = "HelloWorld"
    }
}

resource "aws_instance" "private" {
    ami                 = "ami-064ff912f78e3e561"
    instance_type       = "t2.micro"

    subnet_id           = aws_subnet.private.id

    tags = {
        Name = "HelloWorld"
    }
}