terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.80"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-001"
    storage_account_name = "terraformstatefiles721"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }
}
