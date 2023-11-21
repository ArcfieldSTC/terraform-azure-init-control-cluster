# Creation of Init Control Cluster Resource Group
resource "azurerm_resource_group" "this" {
  name     = "${var.name-prefix}-resource-group"
  location = var.primary_region
  tags     = merge(var.default_tags, var.rg_tags)
}

# Creation of Init Control Cluster NSG
resource "azurerm_network_security_group" "this" {
  name                = "${var.name-prefix}-nsg"
  location            = var.primary_region
  resource_group_name = azurerm_resource_group.this.name
  tags                = merge(var.default_tags, var.sg_tags)
}

# Creation of Init Control Cluster VNet
resource "azurerm_virtual_network" "this" {
  name                = "${var.name-prefix}-vnet"
  location            = var.primary_region
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_cidr]
  tags                = merge(var.default_tags, var.vnet_tags)
  subnet {
    name           = "${var.name-prefix}-subnet"
    address_prefix = var.vnet_cidr
    security_group = azurerm_network_security_group.this.id
  }
}
