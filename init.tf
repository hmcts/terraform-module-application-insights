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
