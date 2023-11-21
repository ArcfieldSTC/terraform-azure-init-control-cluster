# Creation of Init Cluster Resource Group
resource "azurerm_resource_group" "this" {
  name     = "${var.name-prefix}-resource-group"
  location = var.primary_region
  tags     = merge(var.default_tags, var.rg_tags)
}
