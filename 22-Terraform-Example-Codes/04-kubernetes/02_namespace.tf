resource "kubernetes_namespace" "demo" {
  metadata {
    name = var.namespace

    labels = {
      managed-by  = "terraform"
      environment = "demo"
    }
  }
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "app-config"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  data = {
    APP_ENV     = "demo"
    APP_VERSION = "1.0.0"
    MANAGED_BY  = "Terraform"
  }
}
