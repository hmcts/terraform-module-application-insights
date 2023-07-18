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

  common_tags = module.tags.common_tags
}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = "cft-platform"
  builtFrom   = var.builtFrom
}
