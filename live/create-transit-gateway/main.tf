provider "aws" {
    region = "eu-west-1"
}

module "ireland-vpc-setup" {
    source              = "../../modules/generic-vpc-setup"

    vpc_name                    = "terra-one"
    cidr_block                  = "10.1.0.0/16"
    public_sn_cidr_block        = "10.1.1.0/24"
    private_sn_cidr_block       = "10.1.2.0/24"
    private_sn_cidr_block_2     = "10.1.3.0/24"
}

resource "aws_ec2_transit_gateway" "main" {}

resource "aws_ec2_transit_gateway_vpc_attachment" "a" {
  subnet_ids         = [ module.ireland-vpc-setup.private-subnet-id-one, 
                        module.ireland-vpc-setup.private-subnet-id-two, 
                        module.ireland-vpc-setup.public-subnet-id ]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = module.ireland-vpc-setup.vpc-id
}