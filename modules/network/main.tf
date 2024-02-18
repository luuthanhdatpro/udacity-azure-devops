resource "azurerm_virtual_network" "appvnet" {
  name                = "app-network"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  tags = {
    env = "dev"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.appvnet.name
  
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.sec-group.id
}

resource "azurerm_network_security_group" "sec-group" {
  name                = "sec-group"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "allow-inbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sec-group.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "allow-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sec-group.name
}

resource "azurerm_public_ip" "PIP" {
  name                = "appPIP"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    env = "dev"
  }
}

resource "azurerm_lb" "applb" {
  name                = "AppLB"
  location            = var.location
  resource_group_name = var.resource_group_name

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
  name                    = "example"
  backend_address_pool_id = azurerm_lb_backend_address_pool.addpool.id
  virtual_network_id      = azurerm_virtual_network.appvnet.id
  ip_address              = "10.0.0.1"
}