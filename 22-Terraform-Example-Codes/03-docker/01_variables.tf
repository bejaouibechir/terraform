variable "nginx_external_port" {
  description = "Port externe pour accéder à Nginx"
  type        = number
  default     = 8080
}

variable "redis_external_port" {
  description = "Port externe pour accéder à Redis"
  type        = number
  default     = 6379
}

variable "network_name" {
  description = "Nom du réseau Docker créé par Terraform"
  type        = string
  default     = "terraform-network"
}
