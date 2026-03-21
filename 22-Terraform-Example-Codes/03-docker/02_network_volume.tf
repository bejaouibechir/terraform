resource "docker_network" "main" {
  name   = var.network_name
  driver = "bridge"
}

resource "docker_volume" "nginx_data" {
  name = "nginx-data"
}
