# Image Nginx
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Conteneur Nginx
resource "docker_container" "nginx" {
  name  = "nginx-terraform"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.nginx_external_port
  }

  networks_advanced {
    name = docker_network.main.name
  }

  volumes {
    volume_name    = docker_volume.nginx_data.name
    container_path = "/usr/share/nginx/html"
  }

  restart = "unless-stopped"

  labels {
    label = "managed-by"
    value = "terraform"
  }
}

# Image Redis
resource "docker_image" "redis" {
  name         = "redis:alpine"
  keep_locally = false
}

# Conteneur Redis
resource "docker_container" "redis" {
  name  = "redis-terraform"
  image = docker_image.redis.image_id

  ports {
    internal = 6379
    external = var.redis_external_port
  }

  networks_advanced {
    name = docker_network.main.name
  }

  restart = "unless-stopped"

  labels {
    label = "managed-by"
    value = "terraform"
  }
}
