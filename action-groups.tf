locals {
  env = (var.env == "aat") ? "stg" : (var.env == "sandbox") ? "sbox" : "${(var.env == "perftest") ? "test" : "${var.env}"}"

  rg_env = (var.env == "stg" && strcontains(lower(data.azurerm_subscription.current.display_name), "cftapps")) ? "aat" : (var.env == "test" && strcontains(lower(data.azurerm_subscription.current.display_name), "cftapps")) ? "perftest" : var.env == "sandbox" ? "sbox" : var.env

  business_area = strcontains(lower(data.azurerm_subscription.current.display_name), "cnp") || strcontains(lower(data.azurerm_subscription.current.display_name), "cftapps") ? "cft" : "sds"
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

