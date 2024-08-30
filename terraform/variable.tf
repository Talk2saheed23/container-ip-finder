variable "image" {
  description = "The ip-finder container image"
  type        = string
  default     = "fikunmisamson/container-ip-finder:latest"
}

variable "region" {
  description = "region of deployment"
  type        = string
  default     = "East US"
}

variable "subscription_id" {
  description = "The Azure subscription ID"
}

variable "client_id" {
  description = "The Azure client ID"
}

variable "client_secret" {
  description = "The Azure client secret"
}

variable "tenant_id" {
  description = "The Azure tenant ID"
}