
resource "azurerm_resource_group" "demorg" {
  name     = "Udacity"
  location = "eastus"
  tags = {
    env        = "dev"
  }
}

module "network" {
  source = "./modules/network"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
}