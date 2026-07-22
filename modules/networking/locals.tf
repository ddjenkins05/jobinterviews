
locals {
  subnet_base = var.environment == "prod" ? 0 : 128
}

