terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Le provider Kubernetes utilise le fichier ~/.kube/config par défaut
# Adaptez config_context selon votre cluster (minikube, kind, eks, gke...)
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.kube_context
}
