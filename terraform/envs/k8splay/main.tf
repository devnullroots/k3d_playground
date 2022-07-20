data "azurerm_resource_group" "k8splay_resource_group" {
    name    = "1-32e326a5-playground-sandbox"
}
#Create the network

module "k8splay-network" {
    source                      = "../../modules/network"
    
    inherited_tags              = {
        "env" = "acloudguruplayground"
    }
    resource_group_location     = data.azurerm_resource_group.k8splay_resource_group.location
    resource_group_name         = data.azurerm_resource_group.k8splay_resource_group.name
    vpc_cidr                    = var.network["vpc"]["cidr"]
    project_name                = var.project_name
    #just trying something
    subnets                     = var.network["vpc"]["subnets"]
    public_replicas             = var.network["vpc"]["subnets"]["public"]["replicas"]
    vlsm_newbits                = var.network["vpc"]["vlsm_newbits"]
  
}
#Create the Network Security Group. Because it's teh lab i'm gonna reuse the same nsg for all machines 

resource "azurerm_network_security_group" "default_nsg" {
    name                        = "${var.project_name}-default-nsg"
    location                    = data.azurerm_resource_group.k8splay_resource_group.location
    resource_group_name         = data.azurerm_resource_group.k8splay_resource_group.name

}
#Jupiter allow for inbound
resource "azurerm_network_security_rule" "k8splay_jupiter" {
    name                        = "${var.project_name}-sec-rule-jupyter-in"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8888"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.k8splay_resource_group.name
    network_security_group_name = azurerm_network_security_group.default_nsg.name
 
}
#Allow for ssh on default port. Yikes but these environments live for a few hours
resource "azurerm_network_security_rule" "k8splay_ssh" {
    name                        = "${var.project_name}-sec-rule-ssh-in"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.k8splay_resource_group.name
    network_security_group_name = azurerm_network_security_group.default_nsg.name
  
}

#Associate the Network Security Group with the Subnet
resource "azurerm_subnet_network_security_group_association" "k8splay_nsg_assoc" {
    subnet_id                   = module.k8splay-network.subnets[0].id
    network_security_group_id   = azurerm_network_security_group.default_nsg.id
  
}

#Let's grab a public ip

resource "azurerm_public_ip" "k3d_public_ip" {
    name                        = "k3d_public_ip"
    resource_group_name         = data.azurerm_resource_group.k8splay_resource_group.name
    location                    = data.azurerm_resource_group.k8splay_resource_group.location
    allocation_method           = "Static"

}
#Let's create the network interface for the K3D VM
resource "azurerm_network_interface" "k3d_nic" {
    name                        = "k3d_nic"
    location                    = data.azurerm_resource_group.k8splay_resource_group.location
    resource_group_name         = data.azurerm_resource_group.k8splay_resource_group.name

    ip_configuration {
      name                      = "k3d_nic_public_ip"
      subnet_id                 = module.k8splay-network.subnets[0].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id      = azurerm_public_ip.k3d_public_ip.id

    }      
}

#Let's generate a password for the jupyter and the vm. Again. Short-lived VMs
resource "random_password" "k3d_pass" {
    length                      = 16
    special                     = true
    override_special            ="!@#$%^&*_=-"
  
}

#let's inject the password into the saltstack configuration

data "template_file" "minion_config" {
    template                    = file("k3d_azure.yml")
    vars = {
        k3d_password = random_password.k3d_pass.result
    }
  
}
#load the cloud-config

data "template_file" "k3d_cloud_init" {
    template = file("cloud_config.yml")
    vars = {
      k3d_password = random_password.k3d_pass.result
    }
}

#Launch ze VM
resource "azurerm_virtual_machine" "k3d_vm" {
    name                        = "k3d_Virtual_Machine"
    location                    = data.azurerm_resource_group.k8splay_resource_group.location
    resource_group_name         = data.azurerm_resource_group.k8splay_resource_group.name
    network_interface_ids       = [azurerm_network_interface.k3d_nic.id]
    vm_size                     = "Standard_D2s_v3"
    delete_os_disk_on_termination = true 
    storage_image_reference {
      publisher                 = "Canonical"
      offer                     = "0001-com-ubuntu-server-focal"
      sku                       = "20_04-lts"
      version                   = "20.04.202207130"
    }

    storage_os_disk {
      name                      = "k3d_os_disk"
      create_option             = "FromImage"
      disk_size_gb              = 50
      os_type                   = "Linux"

    }

    os_profile {
      computer_name             = "k3d"
      admin_username            = "cloud_azure"
      admin_password            = random_password.k3d_pass.result
      custom_data               = data.template_file.k3d_cloud_init.rendered
    }

    os_profile_linux_config {
      disable_password_authentication = false
    }                        
}