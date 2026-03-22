variable "db_username" {
  description = "Nom d'utilisateur base de données"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "Mot de passe base de données (laisser vide pour générer automatiquement)"
  type        = string
  sensitive   = true
  default     = ""
}
