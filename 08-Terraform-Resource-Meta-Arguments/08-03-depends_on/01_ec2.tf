resource "random_pet" "server" {
  length = 2
  prefix = "web"
}

resource "local_file" "server_config" {
  filename = "${path.module}/output/server.conf"
  content  = "SERVER_NAME=${random_pet.server.id}\nSTATUS=running"
}
