resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx-demo"
    }

    port {
      port        = 80
      target_port = 80
      node_port   = var.node_port
    }

    type = "NodePort"
  }
}
