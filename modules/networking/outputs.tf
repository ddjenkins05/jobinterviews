
output "vnet_name" {
  value = azurerm_virtual_network.test.name
}

output "vnet_id" {
  value = azurerm_virtual_network.test.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet_test.id
}

output "web_subnet_id" {
  value = azurerm_subnet.web_subnet_test.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data_subnet_test.id
}

output "nsg_id" {
  value = azurerm_network_security_group.web_test_nsg.id
}
