
locals {
  env = (var.env == "aat") ? "stg" : (var.env == "sandbox") ? "sbox" : "${(var.env == "perftest") ? "test" : "${var.env}"}"

  business_area = strcontains(lower(data.azurerm_subscription.current.display_name), "cnp") || strcontains(lower(data.azurerm_subscription.current.display_name), "cft") ? "cft" : "sds"
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = var.env == "preview" ? "Application Insights daily cap reached - preview" : "Application Insights daily cap reached"
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


data "http" "cnp_team_config" {
  url = "https://raw.githubusercontent.com/hmcts/cnp-jenkins-config/master/team-config.yml"
}
data "http" "sds_team_config" {
  url = "https://raw.githubusercontent.com/hmcts/sds-jenkins-config/master/team-config.yml"
}

output "channel_id" {
  value = try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") == "" ? try(yamldecode(data.http.sds_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "") : try(yamldecode(data.http.cnp_team_config.response_body)["${var.product}"]["slack"]["channel_id"], "")
}
