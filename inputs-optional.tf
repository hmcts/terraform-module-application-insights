variable "resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  description = "The default name will be product+env, you can override the product part by setting this"
  default     = null
  type        = string
}

variable "application_type" {
  default     = "web" # most of our instances have historically used web, even if other might be more appropriate
  description = "Specifies the type of Application Insights to create. Valid values are `java` for Java web, `Node.JS` for Node.js, `other` for General, and `web` for ASP.NET"
  type        = string
}

variable "sampling_percentage" {
  default     = 100
  description = "Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry."
  type        = number
}

variable "daily_data_cap_in_gb" {
  default     = 50
  description = "Specifies the Application Insights component daily data volume cap in GB"
  type        = number
}

variable "action_group_id" {
  default = "An action group ID for sending alerts to"
  type    = list(string)
}

variable "" {
  default = "An action group ID for sending alerts to"
  type    = list(string)
}

variable "additional_action_group_ids" {
  type    = list(object({
      action_group_name      = string
      short_name             = string
      email_receiver_name    = string
      email_receiver_address = string
      resourcegroup_name     = string
  }))
  default = []
}