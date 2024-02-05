# resource "azurerm_monitor_action_group" "additional_action_groups" {
#   count = length(var.additional_action_group_ids) > 0 ? 1 : 0

#   for_each = { for ag in var.additional_action_group_ids : ag.action_group_name => ag }

#   name                = each.value.action_group_name 
#   resource_group_name = each.value.resourcegroup_name
#   short_name          = each.value.short_name

#   email_receiver {
#      name             = each.value.email_receiver_name
#      email_address    = each.value.email_receiver_address
#     }

#   tags = var.common_tags
# }