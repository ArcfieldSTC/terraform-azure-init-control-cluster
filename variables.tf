#### Common variables
variable "name-prefix" {
  description = "value to be used as prefix for all resources"
  type        = string
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
