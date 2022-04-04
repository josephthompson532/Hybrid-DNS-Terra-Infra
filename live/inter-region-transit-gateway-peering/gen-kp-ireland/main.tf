provider "aws" {
    region = "eu-west-1"
}

resource "tls_private_key" "this" {
    algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
    key_name   = "terraform-key-pair"
    public_key = tls_private_key.this.public_key_openssh
}