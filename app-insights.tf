locals {
  name = var.override_name == null ? (var.name == null ? "${var.product}-${var.env}" : "${var.name}-${var.env}") : var.override_name

  # Production environments get 100% sampling, nonprod gets 1% by default
  sampling_map = {
    prod      = 100
    prd       = 100
    idam-prod = 100
    demo      = 1
    aat       = 1
    ithc      = 1
    dev       = 1
    staging   = 1
    sandbox   = 1
    perftest  = 1
    test      = 1
  }
  sampling_percentage_default = var.sampling_percentage != null ? var.sampling_percentage : lookup(local.sampling_map, lower(var.env), 1)
}

module "log_analytics_workspace_id" {
  source = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id?ref=master"

  environment = var.env
}

resource "azurerm_application_insights" "this" {

  name = local.name

  location            = var.location
  resource_group_name = var.resource_group_name

  application_type     = var.application_type
  daily_data_cap_in_gb = var.daily_data_cap_in_gb
  sampling_percentage  = local.sampling_percentage_default
  workspace_id         = module.log_analytics_workspace_id.workspace_id

  daily_data_cap_notifications_enabled = false

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

output "name" {
  value = azurerm_application_insights.this.name
}

output "id" {
  value = azurerm_application_insights.this.id
}

