resource "aws_ec2_transit_gateway" "main" {}

resource "aws_ec2_transit_gateway_vpc_attachment" "a" {
  subnet_ids         = var.subnets_a
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.main_vpc_id_a
  transit_gateway_default_route_table_association = false

  tags = {
    Name = "attachment-a"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "b" {
  subnet_ids         = var.subnets_b
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.main_vpc_id_b
  transit_gateway_default_route_table_association = false

  tags = {
    Name = "attachment-b"
  }
}

resource "aws_ec2_transit_gateway_route_table" "vpc-one-rt" {
    transit_gateway_id = aws_ec2_transit_gateway.main.id

    tags = {
        Name = "vpc-one-rt"
    }
}

resource "aws_ec2_transit_gateway_route_table" "vpc-two-rt" {
    transit_gateway_id = aws_ec2_transit_gateway.main.id

    tags = {
        Name = "vpc-two-rt"
    }
}

resource "aws_ec2_transit_gateway_route_table_association" "a-rt-assc" {
    transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.a.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc-one-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "b-rt-assc" {
    transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.b.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc-two-rt.id
}

resource "aws_ec2_transit_gateway_route" "a-route-to-b" {
  destination_cidr_block         = var.vpc-setup-two-cidr-range
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc-one-rt.id
}

resource "aws_ec2_transit_gateway_route" "b-route-to-a" {
  destination_cidr_block         = var.vpc-setup-cidr-range
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc-two-rt.id
}