resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "Application Insights daily cap reached"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.this.id]
  description         = "Monitors for application insight reaching it's daily cap."

  criteria {
    resource_id    = azurerm_application_insights.this.id
    operation_name = "Microsoft.Insights/Components/DailyCapReached/Action"
    category       = "Administrative"
    level          = "Warning"
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id

    webhook_properties = {
      from = "terraform"
    }
  }

  tags = var.common_tags
}
