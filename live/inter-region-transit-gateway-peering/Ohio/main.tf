provider "aws" {
    region = "us-east-2"
}

module "ohio-vpc-setup" {
    source              = "../../../modules/generic-vpc-setup"

    vpc_name                    = var.vpc-one-name
    cidr_block                  = var.cidr_block_one
    public_sn_cidr_block        = var.public_sn_cidr_block
    private_sn_cidr_block       = var.private_sn_cidr_block
    private_sn_cidr_block_2     = var.private_sn_cidr_block_2
}

module "ohio-vpc-setup-two" {
    source                      = "../../../modules/generic-vpc-setup"

    vpc_name                    = var.vpc-two-name
    cidr_block                  = var.cidr_block_two
    public_sn_cidr_block        = var.public_sn_cidr_block_two
    private_sn_cidr_block       = var.private_sn_cidr_block_two
    private_sn_cidr_block_2     = var.private_sn_cidr_block_2_two
}

module "transit-gateway-ohio" {
    source                      = "../../../modules/transit-gateway"

    main_vpc_id_a               = module.ohio-vpc-setup.vpc-id
    subnets_a                   = [ module.ohio-vpc-setup.private-subnet-id-one, module.ohio-vpc-setup.private-subnet-id-two, module.ohio-vpc-setup.public-subnet-id ]
    main_vpc_id_b               = module.ohio-vpc-setup-two.vpc-id
    subnets_b                   = [ module.ohio-vpc-setup-two.private-subnet-id-one, module.ohio-vpc-setup-two.private-subnet-id-two, module.ohio-vpc-setup-two.public-subnet-id ]
    vpc-setup-cidr-range = var.cidr_block_one
    vpc-setup-two-cidr-range = var.cidr_block_two

}

resource "aws_route53_resolver_endpoint" "inbound-endpoint-vpc-a" {
    name = "inbound-resolver-vpc-a"
    direction = "INBOUND"

    security_group_ids = [
        module.ohio-vpc-setup.security-group-id
    ]

    ip_address {
        subnet_id = module.ohio-vpc-setup.public-subnet-id
        ip = var.inbound_resolver_ip_one
    }

    ip_address {
        subnet_id = module.ohio-vpc-setup.private-subnet-id-one
        ip = var.inbound_resolver_ip_two
    }

}

resource "aws_route53_resolver_endpoint" "outbound-endpoint-vpc-b"{
    name = "outbound-resolver-vpc-b"
    direction = "OUTBOUND"

    security_group_ids = [
        module.ohio-vpc-setup-two.security-group-id
    ]

    ip_address {
        subnet_id = module.ohio-vpc-setup-two.public-subnet-id
    }

    ip_address {
        subnet_id = module.ohio-vpc-setup-two.private-subnet-id-one
    }

}

resource "aws_route53_resolver_rule" "fwd-a" {
    domain_name             = "terraform-internal-dns-one.com"
    name                    = "inbound-dns-resolution-on-vpc-one"
    rule_type               = "FORWARD"
    resolver_endpoint_id    = aws_route53_resolver_endpoint.outbound-endpoint-vpc-b.id

    target_ip {
        ip = var.inbound_resolver_ip_one
    }
    
}

resource "aws_route53_resolver_rule_association" "main-a" {
    resolver_rule_id = aws_route53_resolver_rule.fwd-a.id
    vpc_id = module.ohio-vpc-setup-two.vpc-id
}

resource "aws_route53_resolver_endpoint" "inbound-endpoint-vpc-b" {
    name = "inbound-resolver-vpc-b"
    direction = "INBOUND"

    security_group_ids = [
        module.ohio-vpc-setup-two.security-group-id
    ]

    ip_address {
        subnet_id = module.ohio-vpc-setup-two.public-subnet-id
        ip = var.inbound_resolver_ip_one_b
    }

    ip_address {
        subnet_id = module.ohio-vpc-setup-two.private-subnet-id-one
        ip = var.inbound_resolver_ip_two_b
    }

}

resource "aws_route53_resolver_endpoint" "outbound-endpoint-vpc-a"{
    name = "outbound-resolver-vpc-a"
    direction = "OUTBOUND"

    security_group_ids = [
        module.ohio-vpc-setup.security-group-id
    ]

    ip_address {
        subnet_id = module.ohio-vpc-setup.public-subnet-id
    }

    ip_address {
        subnet_id = module.ohio-vpc-setup.private-subnet-id-one
    }

}

resource "aws_route53_resolver_rule" "fwd-b" {
    domain_name             = "terraform-internal-dns-two.com"
    name                    = "inbound-dns-resolution-on-vpc-two"
    rule_type               = "FORWARD"
    resolver_endpoint_id    = aws_route53_resolver_endpoint.outbound-endpoint-vpc-a.id

    target_ip {
        ip = var.inbound_resolver_ip_one_b
    }
    
}

resource "aws_route53_resolver_rule_association" "main-b" {
    resolver_rule_id = aws_route53_resolver_rule.fwd-b.id
    vpc_id = module.ohio-vpc-setup.vpc-id
}