# Plusieurs ressources pour démontrer les commandes state
# terraform state list, show, mv, rm

resource "random_pet" "server" {
  length = 2
  prefix = var.environment
}

resource "random_pet" "database" {
  length = 2
  prefix = "db"
}

resource "random_id" "network_id" {
  byte_length = 4
}

resource "local_file" "server_config" {
  filename = "${path.module}/output/server.conf"
  content  = "SERVER=${random_pet.server.id}\nNETWORK_ID=${random_id.network_id.hex}"
}

resource "local_file" "db_config" {
  filename = "${path.module}/output/database.conf"
  content  = "DATABASE=${random_pet.database.id}\nNETWORK_ID=${random_id.network_id.hex}"
}
