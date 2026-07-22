
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

variable "third_octet" {
  type        = string
  description = "Third octet needs to be a number between 0 and 255."
  validation {
    condition     = can(tonumber(var.third_octet)) && tonumber(var.third_octet) >= 0 && tonumber(var.third_octet) <= 255
    error_message = "third_octet must be a number between 0 and 255."
  }
}
