output "namespace" {
  description = "Namespace Kubernetes créé"
  value       = kubernetes_namespace.demo.metadata[0].name
}

output "deployment_name" {
  description = "Nom du déploiement Nginx"
  value       = kubernetes_deployment.nginx.metadata[0].name
}

output "service_name" {
  description = "Nom du service Kubernetes"
  value       = kubernetes_service.nginx.metadata[0].name
}

output "service_node_port" {
  description = "Port NodePort pour accéder à l'application"
  value       = kubernetes_service.nginx.spec[0].port[0].node_port
}

output "kubectl_get_pods" {
  description = "Commande pour vérifier les pods"
  value       = "kubectl get pods -n ${var.namespace}"
}
