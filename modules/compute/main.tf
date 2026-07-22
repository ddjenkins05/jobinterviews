
resource "azurerm_public_ip" "web" {
  name                = "pip-web-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  for_each = local.servers

  name                = "nic-${each.key}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.key == "web" ? azurerm_public_ip.web.id : null
  }
}


data "azurerm_key_vault" "main" {
  name                = "kv-keyvault-centeralus"
  resource_group_name = local.resource_group_key_vaultname
}

data "azurerm_key_vault_secret" "username" {
  name         = "app-username"
  key_vault_id = data.azurerm_key_vault.main.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "app-password"
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each       = local.servers
  admin_username = data.azurerm_key_vault_secret.username.value
  admin_password = data.azurerm_key_vault_secret.password.value

  name                = "vm-${each.key}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2ls_v2"




  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}
