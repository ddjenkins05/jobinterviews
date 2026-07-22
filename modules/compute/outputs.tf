
output "web_vm_id" {
  value = azurerm_windows_virtual_machine.vm["web"].id
}
output "db_vm_id" {
  value = azurerm_windows_virtual_machine.vm["db"].id
}
