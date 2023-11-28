### Resource Group Outputs
output "rg_id" {
  description = "The ID of the Resource Group"
  value       = azurerm_resource_group.this.id
}
output "rg_name" {
  description = "The Name of the Resource Group"
  value       = azurerm_resource_group.this.name
}
output "rg_location" {
  description = "Region of the Resource Group"
  value       = azurerm_resource_group.this.location
}

### Security Group Outputs
output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.this.id
}
output "nsg_name" {
  description = "The Name of the Network Security Group"
  value       = azurerm_network_security_group.this.name
}
output "nsg_rg_name" {
  description = "The name of the Resource Group associated with the NSG"
  value       = azurerm_network_security_group.this.resource_group_name
}
output "nsg_location" {
  description = "The location of the NSG"
  value       = azurerm_network_security_group.this.location
}

### VNet Outputs
output "vnet_id" {
  description = "The ID of the VNet"
  value       = azurerm_virtual_network.this.id
}
output "vnet_name" {
  description = "The name of the VNet"
  value       = azurerm_virtual_network.this.name
}
output "vnet_rg_name" {
  description = "The Resource Group Name associated with the VNet"
  value       = azurerm_virtual_network.this.resource_group_name
}
output "vnet_location" {
  description = "The region the VNet is deployed in"
  value       = azurerm_virtual_network.this.location
}
output "vnet_address_space" {
  description = "The CIDR address space associated with the VNet"
  value       = azurerm_virtual_network.this.address_space
}
output "vnet_guid" {
  description = "The GUID of the VNet"
  value       = azurerm_virtual_network.this.guid
}

### Key Vault Outputs
output "kv_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}
output "kv_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.this.name
}
output "kv_rg_name" {
  description = "The Resource Group Name associated with the Key Vault"
  value       = azurerm_key_vault.this.resource_group_name
}
output "kv_location" {
  description = "The region the Key Vault is deployed in"
  value       = azurerm_key_vault.this.location
}
output "kv_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}
output "kv_tenant_id" {
  description = "The tenant ID of the Key Vault"
  value       = azurerm_key_vault.this.tenant_id
}

### Key Vault Managed HSM Outputs
output "kv_hsm_id" {
  description = "The ID of the Key Vault Managed HSM"
  value       = try(azurerm_key_vault_managed_hardware_security_module.this[0].id, null)
}
output "kv_hsm_name" {
  description = "The name of the Key Vault Managed HSM"
  value       = try(azurerm_key_vault_managed_hardware_security_module.this[0].name, null)
}
output "kv_hsm_location" {
  description = "The region the Key Vault Managed HSM is deployed in"
  value       = try(azurerm_key_vault_managed_hardware_security_module.this[0].location, null)
}
output "kv_hsm_uri" {
  description = "The URI of the Key Vault Managed HSM"
  value       = try(azurerm_key_vault_managed_hardware_security_module.this[0].hsm_uri, null)
}
output "kv_hsm_tenant_id" {
  description = "The tenant ID of the Key Vault Managed HSM"
  value       = try(azurerm_key_vault_managed_hardware_security_module.this[0].tenant_id, null)
}

### CMK Outputs
output "cmk_id" {
  description = "The ID of the Customer Managed Key"
  value       = azurerm_key_vault_key.encrypt-cmk.id
}
output "cmk_name" {
  description = "The name of the Customer Managed Key"
  value       = azurerm_key_vault_key.encrypt-cmk.name
}
output "cmk_version" {
  description = "The version of the Customer Managed Key"
  value       = azurerm_key_vault_key.encrypt-cmk.version
}
output "cmk_versionless_id" {
  description = "The versionless ID of the Customer Managed Key"
  value       = azurerm_key_vault_key.encrypt-cmk.versionless_id
}
output "cmk_resource_versionless_id" {
  description = "The versionless ID of the Customer Managed Key"
  value       = azurerm_key_vault_key.encrypt-cmk.resource_versionless_id
}

### AKS Outputs
output "aks_id" {
  description = "The ID of the AKS Cluster"
  value       = azurerm_kubernetes_cluster.this.id
}
output "aks_name" {
  description = "The name of the AKS Cluster"
  value       = azurerm_kubernetes_cluster.this.name
}
