variable "environment" {
  description = "Nom de l'environnement (dev, staging, prod uniquement)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit être : dev, staging ou prod."
  }
}

variable "server_port" {
  description = "Port du serveur (entre 1024 et 65535)"
  type        = number
  default     = 8080

  validation {
    condition     = var.server_port >= 1024 && var.server_port <= 65535
    error_message = "Le port doit être compris entre 1024 et 65535."
  }
}
