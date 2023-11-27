#### Common variables
variable "name_prefix" {
  description = "value to be used as prefix for all resources"
  type        = string
  default     = "init-control-cluster"
}
variable "primary_region" {
  description = "primary region to deploy resources"
  type        = string
}
variable "default_tags" {
  description = "map of tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

### Resource group variables
variable "rg_tags" {
  description = "map of tags to be applied to resource group"
  type        = map(string)
  default     = {}
}

### Security group variables
variable "sg_tags" {
  description = "map of tags to be applied to security group"
  type        = map(string)
  default     = {}
}

### Virtual network variables
variable "vnet_tags" {
  description = "map of tags to be applied to virtual network"
  type        = map(string)
  default     = {}
}
variable "vnet_cidr" {
  description = "CIDR block for virtual network"
  type        = string
  default     = "192.168.0.0/24"
  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0)) && try(cidrhost(var.vnet_cidr, 0), null) == split("/", var.vnet_cidr)[0]
    error_message = "InvalidCIDRNotation: The Address Space is not a correctly formated CIDR, or the address prefix is invalid for the CIDR's size"
  }
}

### Key Vault variables
variable "kv_tags" {
  description = "map of tags to be applied to key vault"
  type        = map(string)
  default     = {}
}
variable "kv_network_acls_ip_rules" {
  description = "list of IP addresses to be allowed access to key vault"
  type        = list(string)
  default     = []
}
variable "create_managed_hsm" {
  description = "whether to create a managed HSM"
  type        = bool
  default     = false
}
variable "kv_sku" {
  description = "SKU to use for key vault"
  type        = string
  default     = "premium"
}
variable "kv_purge_protection_enabled" {
  description = "whether to enable purge protection for key vault"
  type        = bool
  default     = true
}
variable "kv_softdelete_retention_days" {
  description = "number of days to retain deleted keys in key vault"
  type        = number
  default     = 7
}
variable "kv_disk_encryption_enabled" {
  description = "whether to enable disk encryption for key vault"
  type        = bool
  default     = true
}
variable "kv_deploy_access_policy" {
  description = "whether to enable deployment access policy for key vault"
  type        = bool
  default     = true
}
variable "kv_template_deployment_enabled" {
  description = "whether to enable template deployment for key vault"
  type        = bool
  default     = true
}
variable "kv_rbac_enabled" {
  description = "whether to enable RBAC for key vault"
  type        = bool
  default     = true
}
variable "kv_network_acls_bypass" {
  description = "whether to bypass network ACLs for key vault"
  type        = string
  default     = "AzureServices"
}
variable "kv_network_acls_default_action" {
  description = "default action for network ACLs for key vault"
  type        = string
  default     = "Deny"

}
variable "kv_hsm_sku_name" {
  description = "SKU to use for key vault managed HSM"
  type        = string
  default     = "Standard_B1"

}

### CMK variables
variable "cmk_tags" {
  description = "map of tags to be applied to CMK"
  type        = map(string)
  default     = {}
}
variable "cmk_key_type" {
  description = "type of key to use for CMK RSA or RSA-HSM"
  type        = string
  default     = "RSA-HSM"
}
variable "cmk_key_size" {
  description = "size of key to use for CMK"
  type        = number
  default     = 4096
}
variable "cmk_key_opts" {
  description = "list of key operations to enable for CMK"
  type        = list(string)
  default     = ["encrypt", "decrypt", "wrapKey", "unwrapKey"]

}
variable "cmk_expire_after" {
  description = "number of days after which the CMK will expire"
  type        = string
  default     = "P60D"
}
variable "cmk_notify_before_expiry" {
  description = "number of days before expiration to notify about CMK"
  type        = string
  default     = "P15D"
}
variable "cmk_auto_rotation" {
  description = "number of days before expiration to rotate the CMK"
  type        = string
  default     = "P10D"
}

### User Assigned Identity variables
variable "uai_tags" {
  description = "map of tags to be applied to user assigned identity"
  type        = map(string)
  default     = {}
}

### AKS variables
variable "aks_tags" {
  description = "map of tags to be applied to AKS"
  type        = map(string)
  default     = {}
}
variable "aks_node_count" {
  description = "number of nodes to deploy for AKS"
  type        = number
  default     = 1
}
variable "aks_node_size" {
  description = "size of nodes to deploy for AKS"
  type        = string
  default     = "Standard_D2s_v3"
}
variable "aks_node_os_disk_size" {
  description = "size of OS disk to deploy for AKS nodes"
  type        = number
  default     = 128
}
variable "aks_enable_auto_scaling" {
  description = "whether to enable auto scaling for AKS"
  type        = bool
  default     = true
}
variable "aks_auto_scaling_min_count" {
  description = "minimum number of nodes to deploy for AKS auto scaling"
  type        = number
  default     = 1
}
variable "aks_auto_scaling_max_count" {
  description = "maximum number of nodes to deploy for AKS auto scaling"
  type        = number
  default     = 3
}
variable "aks_enable_host_encryption" {
  description = "whether to enable host encryption for AKS"
  type        = bool
  default     = true
}
variable "aks_os_sku" {
  description = "OS SKU to use for AKS"
  type        = string
  default     = "AzureLinux"
}
variable "aks_fips_enabled" {
  description = "whether to enable FIPS for AKS"
  type        = bool
  default     = true
}
variable "aks_default_node_pool_name" {
  description = "name of default node pool for AKS"
  type        = string
  default     = "default"
}
variable "aks_default_node_pool_type" {
  description = "type of default node pool for AKS"
  type        = string
  default     = "VirtualMachineScaleSets"
}
variable "aks_sku_tier" {
  description = "SKU tier to use for AKS"
  type        = string
  default     = "Standard"
}
variable "aks_api_server_authorized_ip_ranges" {
  description = "list of IP ranges to allow access to AKS API server"
  type        = list(string)
  default     = []
}
variable "aks_vnet_integration_enabled" {
  description = "whether to enable VNet integration for AKS"
  type        = bool
  default     = false
}
variable "aks_auto_channel_upgrade" {
  description = "auto channel upgrade configuration for AKS"
  type        = string
  default     = "patch"
}
variable "aks_rbac_enabled" {
  description = "whether to enable RBAC for AKS"
  type        = bool
  default     = true
}
variable "aks_aad_rbac_managed" {
  description = "whether RBAC should be managed by AAD RBAC for AKS"
  type        = bool
  default     = true
}
variable "aks_aad_rbac_enabled" {
  description = "whether to enable AAD RBAC for AKS"
  type        = bool
  default     = true
}
variable "aks_network_plugin" {
  description = "network plugin to use for AKS"
  type        = string
  default     = "azure"
}
variable "aks_network_policy" {
  description = "network policy to use for AKS"
  type        = string
  default     = "azure"
}
variable "aks_outbound_type" {
  description = "network outbound type to use for AKS"
  type        = string
  default     = "loadBalancer"
}
variable "aks_load_balancer_sku" {
  description = "load balancer SKU to use for AKS"
  type        = string
  default     = "standard"
}
variable "aks_blob_driver_enabled" {
  description = "whether to enable blob driver for AKS"
  type        = bool
  default     = true
}
variable "aks_disk_driver_enabled" {
  description = "whether to enable disk driver for AKS"
  type        = bool
  default     = true
}
variable "aks_file_driver_enabled" {
  description = "whether to enable file driver for AKS"
  type        = bool
  default     = true
}
variable "aks_snapshot_controller_enabled" {
  description = "whether to enable snapshot driver for AKS"
  type        = bool
  default     = true
}
variable "aks_flux_namespace" {
  description = "namespace to deploy flux to for AKS"
  type        = string
  default     = "flux-system"
}
variable "aks_flux_scope" {
  description = "scope to deploy flux to for AKS"
  type        = string
  default     = "cluster"
}
variable "aks_kustomization_name" {
  description = "name of kustomization to deploy for AKS"
  type        = string
  default     = "flux-system"
}
variable "flux_git_url" {
  description = "URL of git repo to use for flux"
  type        = string
  default     = ""
}
variable "flux_git_branch" {
  description = "branch of git repo to use for flux"
  type        = string
  default     = "main"
}
variable "flux_git_reference_type" {
  description = "type of git reference to use for flux"
  type        = string
  default     = "branch"
}
variable "flux_git_https_key_base64" {
  description = "value of git https key to use for flux"
  type        = string
  default     = ""
}
variable "flux_git_https_user" {
  description = "value of git https user to use for flux"
  type        = string
  default     = ""

}
