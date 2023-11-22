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

resource "azurerm_subnet" "main" {
  name                 = "${var.name_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 1, 0)]
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}
resource "azurerm_subnet" "api_dedicated" {
  name                 = "${var.name_prefix}-api-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 1, 1)]
  delegation {
    name = "api-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
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
  sku_name                        = var.kv_sku
  purge_protection_enabled        = var.kv_purge_protection_enabled
  soft_delete_retention_days      = var.kv_softdelete_retention_days
  enabled_for_disk_encryption     = var.kv_disk_encryption_enabled
  enabled_for_deployment          = var.kv_deploy_access_policy
  enabled_for_template_deployment = var.kv_template_deployment_enabled
  enable_rbac_authorization       = var.kv_rbac_enabled
  network_acls {
    default_action             = var.kv_network_acls_default_action
    bypass                     = var.kv_network_acls_bypass
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
  sku_name                   = var.kv_hsm_sku_name
  tags                       = merge(var.default_tags, var.kv_tags)
  purge_protection_enabled   = var.kv_purge_protection_enabled
  soft_delete_retention_days = var.kv_softdelete_retention_days
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  admin_object_ids           = [data.azurerm_client_config.current.object_id]
}

# Creation of HSM CMK to meet the encryption requirements to handle IL5 data in Azure Gov
resource "azurerm_key_vault_key" "encrypt-cmk" {
  name         = "${var.name_prefix}-en-cmk"
  key_type     = var.cmk_key_type
  key_size     = var.cmk_key_size
  key_opts     = var.cmk_key_opts
  key_vault_id = azurerm_key_vault.this.id
  tags         = merge(var.default_tags, var.cmk_tags)
  rotation_policy {
    expire_after = var.cmk_expire_after
    automatic {
      time_before_expiry = var.cmk_auto_rotation
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name_prefix}-aks"
  location            = var.primary_region
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "${var.name_prefix}-aks"
  node_resource_group = "${var.name_prefix}-aks-nodes"
  sku_tier            = var.aks_sku_tier
  default_node_pool {
    name                   = var.aks_default_node_pool_name
    node_count             = var.aks_node_count
    vm_size                = var.aks_node_size
    type                   = var.aks_default_node_pool_type
    enable_auto_scaling    = var.aks_enable_auto_scaling
    enable_host_encryption = var.aks_enable_host_encryption
    min_count              = var.aks_auto_scaling_min_count
    max_count              = var.aks_auto_scaling_max_count
    os_disk_size_gb        = var.aks_node_os_disk_size
    os_sku                 = var.aks_os_sku
    vnet_subnet_id         = azurerm_subnet.this.id
    fips_enabled           = var.aks_fips_enabled
  }
  api_server_access_profile {
    authorized_ip_ranges = var.aks_api_server_authorized_ip_ranges
    subnet_id            = azurerm_subnet.this.id
  }
  lifecycle {
    ignore_changes = [node_count]
  }
}
