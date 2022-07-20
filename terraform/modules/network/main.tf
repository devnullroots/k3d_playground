#VPC
resource "azurerm_virtual_network" "vpc_network" {
    name                = "${var.project_name}-vpc"
    address_space       = [var.vpc_cidr]
    location            = var.resource_group_location
    resource_group_name = var.resource_group_name
    
    tags = merge(var.inherited_tags,{"name"="${var.project_name}-vpc"})

}


#public_subnets: In the future it should be a submodule. Generally i'd rather avoid doing networking with DSL. 
#Hacking hacking for now

resource "azurerm_subnet" "public_subnets" {
    count = var.subnets["public"]["replicas"]
    name = "${var.project_name}-public-subnet-${count.index}"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vpc_network.name
    address_prefixes = [cidrsubnet(var.vpc_cidr,var.vlsm_newbits,count.index)]
 
}