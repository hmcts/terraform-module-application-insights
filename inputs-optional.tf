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

variable "override_name" {
  description = "The default name will be product+env, this override enables a fully custom name" #the primary use case for this is to enable exisiting App Insights to be moved to the module, without redeployment.
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

variable "email_receiver_config" {
  description = "Configuration for email receiver in the action group"
  type        = map(string)
  default     = null
}

variable "alert_limit_reached" {
  description = "Specifies whether the limit of 100 Activity Log Alerts has been met in the current subscription. Setting to true will create a Log Search Alert instead"
  type        = bool
  default     = false
}

variable "alert_location" {
  description = "Target Azure location to deploy the alert"
  type        = string
  default     = "global"
}
