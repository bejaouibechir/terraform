variable "environment" {
  description = "Nom de l'environnement (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "author" {
  description = "Nom de l'auteur de la configuration"
  type        = string
  default     = "Venkatesh"
}

variable "output_dir" {
  description = "Répertoire de sortie pour les fichiers générés"
  type        = string
  default     = "./output"
}
