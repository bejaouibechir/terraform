resource "random_pet" "server" {
  length = 2
  prefix = var.environment
}

resource "local_file" "config" {
  filename = "${path.module}/output/server.conf"
  content  = "SERVER=${random_pet.server.id}\nENV=${var.environment}\nPORT=${var.server_port}"
}

output "server_name" { value = random_pet.server.id }
output "server_port" { value = var.server_port }
