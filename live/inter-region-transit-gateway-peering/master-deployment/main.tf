provider "aws" {
    region = "us-east-2"
}

module "master-deployment-vpc-to-vpc-tg-oh" {
    source = "../Ohio"

    vpc-one-name=var.vpc-one-name
    cidr_block_one=var.cidr_block_one
    public_sn_cidr_block=var.public_sn_cidr_block
    private_sn_cidr_block=var.private_sn_cidr_block
    private_sn_cidr_block_2=var.private_sn_cidr_block_2

    vpc-two-name=var.vpc-two-name
    cidr_block_two=var.cidr_block_two
    public_sn_cidr_block_two=var.public_sn_cidr_block_two
    private_sn_cidr_block_two=var.private_sn_cidr_block_two
    private_sn_cidr_block_2_two=var.private_sn_cidr_block_2_two

}

// module "master-deployment-vpc-to-vpc-tg-ir" {
//     source = "../Ireland"

//     vpc-one-name=var.vpc-one-name
//     cidr_block_one=var.cidr_block_one
//     public_sn_cidr_block=var.public_sn_cidr_block
//     private_sn_cidr_block=var.private_sn_cidr_block
//     private_sn_cidr_block_2=var.private_sn_cidr_block_2

//     vpc-two-name=var.vpc-two-name
//     cidr_block_two=var.cidr_block_two
//     public_sn_cidr_block_two=var.public_sn_cidr_block_two
//     private_sn_cidr_block_two=var.private_sn_cidr_block_two
//     private_sn_cidr_block_2_two=var.private_sn_cidr_block_2_two

// }