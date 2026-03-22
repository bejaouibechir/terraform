variable "environment" {
  description = "Nom de l'environnement"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Nom de l'ingénieur responsable"
  type        = string
  default     = "Venkatesh"
}

variable "instance_count" {
  description = "Nombre de fichiers/instances à créer"
  type        = number
  default     = 1
}
