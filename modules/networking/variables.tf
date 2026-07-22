
variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "address_space" {
  type    = list(string)
  default = []
}

variable "third_octet" {
  type = number
  validation {
    condition     = var.third_octet >= 0 && var.third_octet <= 255
    error_message = "third_octet must be a number between 0 and 255."
  }
}



