resource "aws_route53_zone" "main-vpc-one" {
    name = "terraform-internal-dns-one.com"
    vpc {
        vpc_id = module.ohio-vpc-setup.vpc-id
    }
}

resource "aws_route53_record" "vpc-one-instance-public" {
    zone_id = aws_route53_zone.main-vpc-one.zone_id
    name = "instance-public.terraform-internal-dns-one.com"
    type = "A"
    ttl = "30"
    records = [module.ohio-vpc-setup.public-instance-private-ip]
}

resource "aws_route53_record" "vpc-one-instance-private" {
    zone_id = aws_route53_zone.main-vpc-one.zone_id
    name = "instance-private.terraform-internal-dns-one.com"
    type = "A"
    ttl = "30"
    records = [module.ohio-vpc-setup.private-instance-private-ip]
}

resource "aws_route53_zone" "main-vpc-two" {
    name = "terraform-internal-dns-two.com"
    vpc {
        vpc_id = module.ohio-vpc-setup-two.vpc-id
    }
}

resource "aws_route53_record" "vpc-two-instance-public" {
    zone_id = aws_route53_zone.main-vpc-two.zone_id
    name = "instance-public.terraform-internal-dns-two.com"
    type = "A"
    ttl = "30"
    records = [ module.ohio-vpc-setup-two.public-instance-private-ip ]
}

resource "aws_route53_record" "vpc-two-instance-private" {
    zone_id = aws_route53_zone.main-vpc-two.zone_id
    name = "instance-private.terraform-internal-dns-two.com"
    type = "A"
    ttl = "30"
    records = [ module.ohio-vpc-setup-two.private-instance-private-ip ]
}