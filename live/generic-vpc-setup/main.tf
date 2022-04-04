provider "aws" {
    region = "eu-west-1"
}

module "transit-gateway-three-vpc_1" {
    source                      = "../../modules/generic-vpc-setup"

    vpc_name                    = "terra-one"
    cidr_block                  = "10.1.0.0/16"
    public_sn_cidr_block        = "10.1.1.0/24"
    private_sn_cidr_block       = "10.1.2.0/24"
    private_sn_cidr_block_2     = "10.1.3.0/24"
}

module "transit-gateway-three-vpc_2" {
    source                      = "../../modules/generic-vpc-setup"

    vpc_name                    = "terra-two"
    cidr_block                  = "10.2.0.0/16"
    public_sn_cidr_block        = "10.2.1.0/24"
    private_sn_cidr_block       = "10.2.2.0/24"
    private_sn_cidr_block_2     = "10.2.3.0/24"
}

module "transit-gateway-three-vpc_3" {
    source                      = "../../modules/generic-vpc-setup"

    vpc_name                    = "terra-three"
    cidr_block                  = "10.3.0.0/16"
    public_sn_cidr_block        = "10.3.1.0/24"
    private_sn_cidr_block       = "10.3.2.0/24"
    private_sn_cidr_block_2     = "10.3.3.0/24"
}