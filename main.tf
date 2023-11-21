data "azurerm_client_config" "current" {}

# Creation of Init Control Cluster Resource Group
resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-resource-group"
  location = var.primary_region
  tags     = merge(var.default_tags, var.rg_tags)
}

# Creation of Init Control Cluster NSG
resource "azurerm_network_security_group" "this" {
  name                = "${var.name_prefix}-nsg"
  location            = var.primary_region
  resource_group_name = azurerm_resource_group.this.name
  tags                = merge(var.default_tags, var.sg_tags)
}

# Creation of Init Control Cluster VNet
resource "azurerm_virtual_network" "this" {
  name                = "${var.name_prefix}-vnet"
  location            = var.primary_region
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_cidr]
  tags                = merge(var.default_tags, var.vnet_tags)
}

resource "azurerm_subnet" "this" {
  name                 = "${var.name_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.vnet_cidr]
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}
resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# Creation of Init Control Cluster Key Vault
resource "azurerm_key_vault" "this" {
  name                            = "${var.name_prefix}-keyvault"
  location                        = var.primary_region
  resource_group_name             = azurerm_resource_group.this.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  purge_protection_enabled        = true
  soft_delete_retention_days      = 7
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = var.kv_network_acls_ip_rules
    virtual_network_subnet_ids = azurerm_virtual_network.this.subnet.*.id
  }
  tags = merge(var.default_tags, var.kv_tags)
}


