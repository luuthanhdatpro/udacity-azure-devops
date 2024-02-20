terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "<rgname>"
      storage_account_name = "<storage-account-name>"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
