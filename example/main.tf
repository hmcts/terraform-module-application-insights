resource "azurerm_resource_group" "this" {
  name     = "${var.product}-${var.env}-rg"
  location = var.location

  tags = module.tags.common_tags
}

module "this" {
  source  = "../"
  product = var.product
  env     = var.env

  resource_group_name = azurerm_resource_group.this.name

  daily_data_cap_in_gb = "0.07"
  email_receiver_config = {
    name              = "test"
    email_address     = "test@justice.gov.uk"
  }

  common_tags = module.tags.common_tags
}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = "cft-platform"
  builtFrom   = var.builtFrom
}

output "connection_string" {
  value     = module.this.connection_string
  sensitive = true
}