variable "main_vpc_id_a" {
    description = "transit gateway attachment"
    type = string
}

variable "subnets_a" {
    description = "include all subnets"
    type        = list(string)
}

variable "main_vpc_id_b" {
    description = "transit gateway attachment"
    type = string
}

variable "subnets_b" {
    description = "include all subnets"
    type        = set(string)
}

variable "vpc-setup-cidr-range" {
    type = string
}

variable "vpc-setup-two-cidr-range" {
    type = string
}