locals {
  env           = var.env == "sandbox" ? "sbox" : var.env
  business_area = strcontains(lower(data.azurerm_subscription.current.display_name), "cnp") || strcontains(lower(data.azurerm_subscription.current.display_name), "cftapps") ? "cft" : "sds"

  # aks_subscription_id = local.business_area == "cft" && local.env == "sbox" ? "b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb" : local.business_area == "cft" && local.env == "aat" ? "96c274ce-846d-4e48-89a7-d528432298a7" : local.business_area == "cft" && local.env == "demo" ? "d025fece-ce99-4df2-b7a9-b649d3ff2060" : local.business_area == "cft" && local.env == "ithc" ? "62864d44-5da9-4ae9-89e7-0cf33942fa09" : local.business_area == "cft" && local.env == "perftest" ? "8a07fdcd-6abd-48b3-ad88-ff737a4b9e3c" : local.business_area == "cft" && local.env == "prod" ? "8cbc6f36-7c56-4963-9d36-739db5d00b27" : local.business_area == "sds" && local.env == "demo" ? "c68a4bed-4c3d-4956-af51-4ae164c1957c" : local.business_area == "sds" && local.env == "ithc" ? "ba71a911-e0d6-4776-a1a6-079af1df7139" : local.business_area == "sds" && local.env == "prod" ? "5ca62022-6aa2-4cee-aaa7-e7536c8d566c" : local.business_area == "sds" && local.env == "sbox" ? "a8140a9e-f1b0-481f-a4de-09e2ee23f7ab" : local.business_area == "sds" && local.env == "stg" ? "74dacd4f-a248-45bb-a2f0-af700dc4cf68" : local.business_area == "sds" && local.env == "test" ? "3eec5bde-7feb-4566-bfb6-805df6e10b90" : ""

}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

data "azurerm_subscriptions" "available" {
  display_name_prefix = local.business_area == "cft" ? "DCD-CFTAPPS-${local.env}" : local.business_area == "sds" ? "DTS-SHAREDSERVICES-${local.env}" : ""
}

data "azurerm_windows_function_app" "alerts" {
  provider            = azurerm.private_endpoint
  name                = "${local.business_area}-alerts-slack-${local.env}"
  resource_group_name = "${local.business_area}-alerts-slack-${local.env}"
}

data "azurerm_function_app_host_keys" "host_keys" {
  provider            = azurerm.private_endpoint
  name                = data.azurerm_windows_function_app.alerts.name
  resource_group_name = "${local.business_area}-alerts-slack-${local.env}"
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "${title(var.product)}-${title(var.env)}-Warning-Alerts"
  resource_group_name = var.resource_group_name
  short_name          = "${substr(var.product, 0, 3)}-${local.env}"

  azure_function_receiver {
    function_app_resource_id = data.azurerm_windows_function_app.alerts.id
    function_name            = "httpTrigger"
    http_trigger_url         = "https://${data.azurerm_windows_function_app.alerts.default_hostname}/api/httpTrigger?code=${data.azurerm_function_app_host_keys.host_keys.default_function_key}"
    name                     = "slack-alerts"
    use_common_alert_schema  = true
  }
  dynamic "email_receiver" {
    for_each = var.email_receiver_config != null ? [var.email_receiver_config] : []
    content {
      name          = email_receiver.value["name"]
      email_address = email_receiver.value["email_address"]
    }
  }

  tags = var.common_tags
}
