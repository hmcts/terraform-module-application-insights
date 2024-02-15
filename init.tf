terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }
}

# provider "azurerm" {
#   features {}
#   skip_provider_registration = true
#   alias                      = "private_endpoint"
#   subscription_id            = data.azurerm_subscriptions.available.subscriptions[0].subscription_id
# }

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "ptl_subscription"
  subscription_id            = local.business_area == "sds" ? "6c4d2513-a873-41b4-afdd-b05a33206631" : "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}
