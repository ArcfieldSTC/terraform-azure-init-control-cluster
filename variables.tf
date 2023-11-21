#### Common variables
variable "name-prefix" {
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
