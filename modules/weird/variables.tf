variable "cidr_block" {
    description = "The cidr block in the vpc"
    type = "string"
}

variable "public_sn_cidr_block" {
    description = "The subnet cidr for the public subnet"
    type = "string"
}

variable "private_sn_cidr_block" {
    description = "The subnet cidr for the private subnet"
    type = "string"
}