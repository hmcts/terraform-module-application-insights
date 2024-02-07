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
