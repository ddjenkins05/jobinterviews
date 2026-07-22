resource "azurerm_storage_account" "test_storage" {
  name                     = "stms${var.environment}001123"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "test_container" {
  name                  = "storage-ms-${var.environment}-001"
  storage_account_id    = azurerm_storage_account.test_storage.id
  container_access_type = "private"
}
