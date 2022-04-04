resource "aws_route" "a-to-b-public" {
    route_table_id = module.ohio-vpc-setup.public-subnet-route-table-id
    destination_cidr_block = module.ohio-vpc-setup-two.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ohio.transit-gateway-id
}

resource "aws_route" "a-to-b-private" {
    route_table_id = module.ohio-vpc-setup.private-subnet-route-table-id
    destination_cidr_block = module.ohio-vpc-setup-two.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ohio.transit-gateway-id
}

resource "aws_route" "b-to-a-public" {
    route_table_id = module.ohio-vpc-setup-two.public-subnet-route-table-id
    destination_cidr_block = module.ohio-vpc-setup.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ohio.transit-gateway-id
}

resource "aws_route" "b-to-a-private" {
    route_table_id = module.ohio-vpc-setup-two.private-subnet-route-table-id
    destination_cidr_block = module.ohio-vpc-setup.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ohio.transit-gateway-id
}