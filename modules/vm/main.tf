resource "azurerm_virtual_machine" "vm" {
    name                        = "Udacity-prj-vm"
    location                    = var.location
    resource_group_name         = var.resource_group_name
    network_interface_ids       = var.network_interface_ids 
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
    location                        = var.location
    resource_group_name             = var.resource_group_name
    platform_fault_domain_count     = var.platform_fault_domain_count
    platform_update_domain_count    = var.platform_update_domain_count
}