locals {
  resource_group_name = "rg-ms-${var.environment}-001"
}

locals {
  resource_group_key_vaultname = "rg-keyvault"
}

locals {
  servers = {
    web = {
      subnet_id = var.web_subnet_id
    }

    db = {
      subnet_id = var.data_subnet_id
    }
  }
}
