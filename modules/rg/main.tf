# create resources
# create RG
resource "azurerm_resource_group" "dollar-rg" {
  name     = "${var.base_name}-RG"
  location =  var.location
  tags = {
    "key" = "dollar-rg-RG"
  }
}

