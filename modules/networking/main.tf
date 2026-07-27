
resource "azurerm_virtual_network" "test" {
  name                = "vnet-ms-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [format("172.16.%s.0/24", var.third_octet)]
}

resource "azurerm_subnet" "app_subnet_test" {
  name                 = "app-ms-${var.environment}-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.test.name

  address_prefixes = [format("172.16.%d.%d/27", var.third_octet, local.subnet_base)
  ]

}

resource "azurerm_subnet" "web_subnet_test" {
  name                 = "web-ms-${var.environment}-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.test.name

  address_prefixes = [format("172.16.%d.%d/27", var.third_octet, local.subnet_base + 32)
  ]


}

resource "azurerm_subnet" "data_subnet_test" {
  name                 = "data-ms-${var.environment}-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes = [format("172.16.%d.%d/27", var.third_octet, local.subnet_base + 64)
  ]
}
resource "azurerm_network_security_group" "web_test_nsg" {
  name                = "nsg-web-ms-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-bastion-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"

  }

  security_rule {
    name                       = "allow-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "block-http"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "block-rdp"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "db_test_nsg" {
  name                = "nsg-db-ms-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-bastion-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"

  }

  security_rule {
    name                       = "block-rdp"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg" {
  subnet_id                 = azurerm_subnet.web_subnet_test.id
  network_security_group_id = azurerm_network_security_group.web_test_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg" {
  subnet_id                 = azurerm_subnet.data_subnet_test.id
  network_security_group_id = azurerm_network_security_group.db_test_nsg.id
}

data "azurerm_virtual_network" "mgmt_network" {
  name                = "vnet-management"
  resource_group_name = "rg-management-infra"
}

output "id" {
  value = azurerm_virtual_network_peering.tomagmt_vnet_peering.id
}

resource "azurerm_virtual_network_peering" "tomagmt_vnet_peering" {
  name                      = "${azurerm_virtual_network.test.name}-to-mgmt"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.test.name
  remote_virtual_network_id = data.azurerm_virtual_network.mgmt_network.id
}

resource "azurerm_virtual_network_peering" "frommgmt_vnet_peering" {
  name                      = "management-to-${azurerm_virtual_network.test.name}"
  resource_group_name       = data.azurerm_virtual_network.mgmt_network.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.mgmt_network.name
  remote_virtual_network_id = azurerm_virtual_network.test.id
}
