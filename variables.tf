variable "resource_group_name" {
  description = "Name of the resource group"
  default = "Udacity"
}

variable "location" {
  description = "Location of the resource group"
  default = "southeastasia"
}

variable "vm_count" {
  description = "Number of NIC"
  default = 2
}

variable "image_id" {
  description = "Image ID"
  default = "/subscriptions/894dff76-a758-451b-9ab3-9af2045d5e1f/resourceGroups/Udacity/providers/Microsoft.Compute/images/demoimage"
}

variable "platform_fault_domain_count" {
  description = "Fault domain count"
  default     = 1
  
}

variable "platform_update_domain_count" {
  description   = "Update domain count"
  default       = 1
}

variable "admin_password" {
  description = "Password of admin"
  default     = "Ud4c!ty"
}

variable "admin_username" {
  description = "Password of admin"
  default     = "udacity"
}

variable "vm_size" {
  description = "VM's size"
  default     = "Standard_A1_v2"
}