variable "resource_group_name" {
  description = "Name of resource group"
  default     = null
}

variable "location" {
  description = "Location"
  default     = null
}

variable "network_interface_ids" {
  description = "Network interface"
  default = null
}

variable "image_id" {
  description = "Image ID"
  default = null
}

variable "platform_fault_domain_count" {
  description = "Fault domain count"
  default     = 1
  
}

variable "platform_update_domain_count" {
  description   = "Update domain count"
  default       = 1
}