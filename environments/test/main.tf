resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
}


module "networking" {
  source = "../../modules/networking"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  third_octet         = var.third_octet

}

module "storage" {
  source = "../../modules/storage"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

module "keyvault" {
  source = "../../modules/keyvault"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

module "compute" {
  source = "../../modules/compute"

  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  web_subnet_id       = module.networking.web_subnet_id
  data_subnet_id      = module.networking.data_subnet_id
  depends_on          = [module.networking]
}
