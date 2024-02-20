
resource "azurerm_resource_group" "demorg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    env        = "dev"
  }
}

resource "azurerm_virtual_network" "appvnet" {
  name                = "app-network"
  location            = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    env = "dev"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.demorg.name
  virtual_network_name = azurerm_virtual_network.appvnet.name
  
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "netinterface" {
  name                = "nic"
  location            = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.sec-group.id
}

resource "azurerm_network_security_group" "sec-group" {
  name                = "sec-group"
  location            = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
}

resource "azurerm_network_security_rule" "outboundrule" {
  name                        = "allow-inbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demorg.name
  network_security_group_name = azurerm_network_security_group.sec-group.name
}

resource "azurerm_network_security_rule" "inboundrule" {
  name                        = "allow-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demorg.name
  network_security_group_name = azurerm_network_security_group.sec-group.name
}

resource "azurerm_public_ip" "PIP" {
  name                = "appPIP"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    env = "dev"
  }
}

resource "azurerm_lb" "applb" {
  name                = "AppLB"
  location            = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.PIP.id
  }
}

resource "azurerm_lb_backend_address_pool" "addpool" {
  loadbalancer_id = azurerm_lb.applb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "addpooladd" {
  name                    = "address-pool-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.addpool.id
  virtual_network_id      = azurerm_virtual_network.appvnet.id
  ip_address              = azurerm_network_interface.netinterface.private_ip_address
}

resource "azurerm_virtual_machine" "vm" {
    name                        = "Udacity-prj-vm"
    location                    = azurerm_resource_group.demorg.location
    resource_group_name         = azurerm_resource_group.demorg.name
    network_interface_ids       = [azurerm_network_interface.netinterface.id]
    vm_size                     = "${var.vm_size}"
    os_profile_linux_config {
      disable_password_authentication = false
    }
    os_profile {
      computer_name  = "server"
      admin_password = "${var.admin_password}"
      admin_username = "${var.admin_username}"
    }
    storage_os_disk {
      name              = "osdisk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
    # storage_data_disk {
    #   name              = "datadisk"
    #   caching           = "ReadWrite"
    #   create_option     = "Attach"
    #   managed_disk_type = "Standard_LRS"
    #   disk_size_gb      = 6
    #   lun               = 3
    # }   
    storage_image_reference {
      id = var.image_id
    }
    availability_set_id = azurerm_availability_set.avail-set.id
}

resource "azurerm_availability_set" "avail-set" {
    name                            = "availability-set"
    location                        = azurerm_resource_group.demorg.location
    resource_group_name             = azurerm_resource_group.demorg.name
    platform_fault_domain_count     = var.platform_fault_domain_count
    platform_update_domain_count    = var.platform_update_domain_count
}
# module "network" {
#   source = "./modules/network"
#   resource_group_name = azurerm_resource_group.demorg.name
#   location            = azurerm_resource_group.demorg.location
# }

# module "vm" {
#   source = "./modules/vm"
#   resource_group_name   = azurerm_resource_group.demorg.name
#   location              = azurerm_resource_group.demorg.location
#   network_interface_ids = [module.network.network_interface_ids]
#   image_id              = "/subscriptions/894dff76-a758-451b-9ab3-9af2045d5e1f/resourceGroups/Udacity/providers/Microsoft.Compute/images/demoimage"
# } 