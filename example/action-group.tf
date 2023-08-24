data "azurerm_windows_function_app" "alerts" {
  name                = "alerts-slack-sandbox"
  resource_group_name = "alerts-slack-sandbox"
}

data "azurerm_function_app_host_keys" "this" {
  name                = data.azurerm_windows_function_app.alerts.name
  resource_group_name = "alerts-slack-sandbox"
}

resource "azurerm_monitor_action_group" "example" {
  name                = "AI-Example-Warning-Alerts"
  resource_group_name = azurerm_resource_group.this.name
  short_name          = "ai-poc"

  azure_function_receiver {
    function_app_resource_id = data.azurerm_windows_function_app.alerts.id
    function_name            = "httpTrigger"
    http_trigger_url         = "https://${data.azurerm_windows_function_app.alerts.default_hostname}/api/httpTrigger?code=${data.azurerm_function_app_host_keys.this.primary_key}"
    name                     = "slack-alerts"
    use_common_alert_schema  = true
  }

  tags = module.tags.common_tags
}
