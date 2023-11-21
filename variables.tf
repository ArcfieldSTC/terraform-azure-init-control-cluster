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
