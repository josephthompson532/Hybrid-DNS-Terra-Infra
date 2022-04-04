provider "aws" {
    region = "eu-west-1"
}

module "ireland-vpc-setup" {
    source              = "../../../modules/generic-vpc-setup"

    vpc_name                    = "terra-one"
    cidr_block                  = "10.1.0.0/16"
    public_sn_cidr_block        = "10.1.1.0/24"
    private_sn_cidr_block       = "10.1.2.0/24"
    private_sn_cidr_block_2     = "10.1.3.0/24"
}

module "ireland-vpc-setup-two" {
    source                      = "../../../modules/generic-vpc-setup"

    vpc_name                    = "terra-two"
    cidr_block                  = "10.2.0.0/16"
    public_sn_cidr_block        = "10.2.1.0/24"
    private_sn_cidr_block       = "10.2.2.0/24"
    private_sn_cidr_block_2     = "10.2.3.0/24"
}

module "transit-gateway-ireland" {
    source                      = "../../../modules/transit-gateway"

    main_vpc_id_a               = module.ireland-vpc-setup.vpc-id
    subnets_a                   = [ module.ireland-vpc-setup.private-subnet-id-one, module.ireland-vpc-setup.private-subnet-id-two, module.ireland-vpc-setup.public-subnet-id ]
    main_vpc_id_b               = module.ireland-vpc-setup-two.vpc-id
    subnets_b                   = [ module.ireland-vpc-setup-two.private-subnet-id-one, module.ireland-vpc-setup-two.private-subnet-id-two, module.ireland-vpc-setup-two.public-subnet-id ]
    vpc-setup-cidr-range = var.cidr_block_one
    vpc-setup-two-cidr-range = var.cidr_block_two

}

resource "aws_route" "a-to-b-public" {
    route_table_id = module.ireland-vpc-setup.public-subnet-route-table-id
    destination_cidr_block = module.ireland-vpc-setup-two.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ireland.transit-gateway-id
}

resource "aws_route" "a-to-b-private" {
    route_table_id = module.ireland-vpc-setup.private-subnet-route-table-id
    destination_cidr_block = module.ireland-vpc-setup-two.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ireland.transit-gateway-id
}

resource "aws_route" "b-to-a-public" {
    route_table_id = module.ireland-vpc-setup-two.public-subnet-route-table-id
    destination_cidr_block = module.ireland-vpc-setup.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ireland.transit-gateway-id
}

resource "aws_route" "b-to-a-private" {
    route_table_id = module.ireland-vpc-setup-two.private-subnet-route-table-id
    destination_cidr_block = module.ireland-vpc-setup.vpc-cidr-range
    transit_gateway_id = module.transit-gateway-ireland.transit-gateway-id
}