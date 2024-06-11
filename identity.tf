# Temporary identity for log search alert. Used as workaround to upstream https://github.com/hashicorp/terraform-provider-azurerm/issues/25921 
resource "azurerm_user_assigned_identity" "this" {
  name                = "log-search-identity-temp-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.common_tags
}

resource "azurerm_role_assignment" "log_search_identity" {
  scope                = data.azurerm_log_analytics_workspace.workspace.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}
