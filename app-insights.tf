locals {
  name = var.name == null ? "${var.product}-${var.env}" : "${var.name}-${var.env}"
}

module "log_analytics_workspace_id" {
  source = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id?ref=master"

  environment = var.env
}

resource "azurerm_application_insights" "this" {
  name = local.name

  location            = var.location
  resource_group_name = var.resource_group_name

  application_type     = var.application_type
  daily_data_cap_in_gb = var.daily_data_cap_in_gb
  sampling_percentage  = var.sampling_percentage
  workspace_id         = module.log_analytics_workspace_id.workspace_id

  tags = var.common_tags
}

output "instrumentation_key" {
  value = azurerm_application_insights.this.instrumentation_key
}

output "connection_string" {
  value = azurerm_application_insights.this.connection_string
}

output "app_id" {
  value = azurerm_application_insights.this.app_id
}