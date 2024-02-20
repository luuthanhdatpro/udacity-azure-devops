
resource "azurerm_resource_group" "demorg" {
  name     = "Udacity"
  location = "southeastasia"
  tags = {
    env        = "dev"
  }
}

module "network" {
  source = "./modules/network"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
}

module "vm" {
  source = "./modules/vm"
  resource_group_name   = azurerm_resource_group.demorg.name
  location              = azurerm_resource_group.demorg.location
  network_interface_ids = [module.network.network_interface_ids]
  image_id              = "/subscriptions/894dff76-a758-451b-9ab3-9af2045d5e1f/resourceGroups/Udacity/providers/Microsoft.Compute/images/demoimage"
} 