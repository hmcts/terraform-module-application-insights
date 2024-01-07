variable "env" {
  description = "Environment value"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to resources"
  type        = map(string)
}

variable "product" {
  description = "https://hmcts.github.io/glossary/#product"
  type        = string
}

variable "action_group_id" {
  default = "An action group ID for sending alerts to"
  type    = string
}
