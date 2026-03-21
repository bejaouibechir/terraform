variable "kube_context" {
  description = "Contexte kubectl à utiliser (minikube, kind-terraform-demo, etc.)"
  type        = string
  default     = "minikube"
}

variable "namespace" {
  description = "Namespace Kubernetes créé par Terraform"
  type        = string
  default     = "terraform-demo"
}

variable "app_replicas" {
  description = "Nombre de réplicas pour le déploiement Nginx"
  type        = number
  default     = 2
}

variable "nginx_image" {
  description = "Image Docker pour Nginx"
  type        = string
  default     = "nginx:latest"
}

variable "node_port" {
  description = "Port NodePort pour exposer le service"
  type        = number
  default     = 30080
}
