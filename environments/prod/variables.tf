variable "environment" {
  type = string

  validation {
    condition     = contains(["test", "prod"], var.environment)
    error_message = "Environment must be either 'test' or 'prod'."
  }
}

variable "location" {
  type    = string
  default = "Central US"
}

variable "resource_group_name" {
  description = "Name of the shared resource group"
  type        = string
}

variable "third_octet" {
  type        = string
  description = "Third octet for networking (0-255). Provided by user via -var or tfvars."
  validation {
    condition     = can(tonumber(var.third_octet)) && tonumber(var.third_octet) >= 0 && tonumber(var.third_octet) <= 255
    error_message = "third_octet must be a number between 0 and 255."
  }
}
