variable "vpc_cidr"{}
variable "project_name" {}
variable "resource_group_name" {}
variable "resource_group_location" {}
variable "public_replicas" {}
variable "vlsm_newbits" {}
variable "subnets" {}


variable "setup_bastion" {
    type = bool
    default = false

}
variable "setup_nat" {
    type = bool
    default = false
}

variable "inherited_tags" {}


