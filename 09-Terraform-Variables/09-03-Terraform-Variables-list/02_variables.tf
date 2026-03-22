variable "environment" {
  type    = string
  default = "dev"
}

variable "server_names" {
  description = "Liste des noms de serveurs"
  type        = list(string)
  default     = ["web-01", "web-02", "api-01"]
}
