resource "azurerm_user_assigned_identity" "example_user_identity" {
  location            = azurerm_resource_group.test_rg.location
  name                = "example"
  resource_group_name = azurerm_resource_group.test_rg.name
}

resource "azurerm_public_ip" "pip_outbound" {

  name                = format("%s-outbound-pip-d", local.project)
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = [1, 2, 3]

  tags = var.tags
}

# resource "azurerm_role_assignment" "vnet_outbound_role" {

#   scope                = azurerm_public_ip.pip_outbound.id
#   role_definition_name = "Network Contributor"
#   principal_id         = azurerm_user_assigned_identity.example_user_identity.principal_id

#   depends_on = [azurerm_user_assigned_identity.example_user_identity]

# }