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
}

variable "sampling_percentage" {
  default     = 100
  description = "Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry."
}

variable "daily_data_cap_in_gb" {
  default     = 100
  description = "Specifies the Application Insights component daily data volume cap in GB"
}
