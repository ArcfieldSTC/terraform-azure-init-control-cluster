data "azurerm_client_config" "current" {}

# Creation of Init Control Cluster Resource Group
resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-rg"
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
  name                            = "${var.name_prefix}-kv"
  location                        = var.primary_region
  resource_group_name             = azurerm_resource_group.this.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "premium"
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

# Providing terraform service prinicpal access to the key vault to make keys
resource "azurerm_role_assignment" "kv_rbac_co" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Creation of Init Control Cluster Key Vault HSM
resource "azurerm_key_vault_managed_hardware_security_module" "this" {
  count                      = var.create_managed_hsm == true ? 1 : 0
  name                       = "${var.name_prefix}-kv-hsm"
  location                   = var.primary_region
  resource_group_name        = azurerm_resource_group.this.name
  sku_name                   = "Standard_B1"
  tags                       = merge(var.default_tags, var.kv_tags)
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  admin_object_ids           = [data.azurerm_client_config.current.object_id]
}

# Creation of HSM CMK to meet the encryption requirements to handle IL5 data in Azure Gov
resource "azurerm_key_vault_key" "encrypt-cmk" {
  name         = "${var.name_prefix}-en-cmk"
  key_type     = "RSA-HSM"
  key_size     = 4096
  key_opts     = ["encrypt", "decrypt", "wrapKey", "unwrapKey"]
  key_vault_id = azurerm_key_vault.this.id
  tags         = merge(var.default_tags, var.kv_tags)
  rotation_policy {
    expire_after = "P7D"
    automatic {
      time_before_expiry = "P3D"
    }
  }
}

