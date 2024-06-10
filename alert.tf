
locals {
  env = (var.env == "aat") ? "stg" : (var.env == "sandbox") ? "sbox" : "${(var.env == "perftest") ? "test" : "${var.env}"}"

  business_area = strcontains(lower(data.azurerm_subscription.current.display_name), "cnp") || strcontains(lower(data.azurerm_subscription.current.display_name), "cft") ? "cft" : "sds"

  log_analytics_name = (var.env == "prod") ? "hmcts-prod" : (var.env == "aat" || var.env == "demo") ? "hmcts-nonprod" : (var.env == "perftest" || var.env == "ithc") ? "hmcts-qa" : "hmcts-sandbox"
  log_analytics_rg   = "oms-automation"
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

data "azurerm_log_analytics_workspace" "workspace" {
  name                = local.log_analytics_name
  resource_group_name = local.log_analytics_rg
}

resource "azurerm_monitor_activity_log_alert" "main" {
  count               = var.alert_limit_reached ? 0 : 1
  name                = "Application Insights daily cap reached - ${local.name}"
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
    action_group_id = local.business_area == "sds" ? "/subscriptions/6c4d2513-a873-41b4-afdd-b05a33206631/resourceGroups/sds-alerts-slack-ptl/providers/Microsoft.Insights/actiongroups/sds-alerts-slack-warning-alerts" : "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/cft-alerts-slack-ptl/providers/Microsoft.Insights/actionGroups/cft-alerts-slack-warning-alerts"

    webhook_properties = {
      from           = "terraform"
      slackChannelId = try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") == "" ? try(yamldecode(data.http.sds_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") : try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "")
    }
  }

  tags = var.common_tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "main" {
  count                = var.alert_limit_reached ? 1 : 0
  name                 = "Application Insights daily cap reached - ${local.name}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  severity             = 4
  scopes               = [data.azurerm_log_analytics_workspace.workspace.id]
  description          = "Monitors for application insight reaching it's daily cap."

  criteria {
    query                   = "Heartbeat | where TimeGenerated > ago(5m)"
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0
  }

  action {
    action_groups = local.business_area == "sds" ? ["/subscriptions/6c4d2513-a873-41b4-afdd-b05a33206631/resourceGroups/sds-alerts-slack-ptl/providers/Microsoft.Insights/actiongroups/sds-alerts-slack-warning-alerts"] : ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/cft-alerts-slack-ptl/providers/Microsoft.Insights/actionGroups/cft-alerts-slack-warning-alerts", "/subscriptions/1c4f0704-a29e-403d-b719-b90c34ef14c9/resourceGroups/docmosis-infrastructure-demo/providers/microsoft.insights/actiongroups/cft-test-email-alert"]

    custom_properties = {
      from           = "terraform"
      slackChannelId = try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") == "" ? try(yamldecode(data.http.sds_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") : try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "")
    }
  }

  tags = var.common_tags
}


data "http" "cnp_team_config" {
  url = "https://raw.githubusercontent.com/hmcts/cnp-jenkins-config/master/team-config.yml"
}
data "http" "sds_team_config" {
  url = "https://raw.githubusercontent.com/hmcts/sds-jenkins-config/master/team-config.yml"
}

output "channel_id" {
  value = try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") == "" ? try(yamldecode(data.http.sds_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") : try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "")
}
