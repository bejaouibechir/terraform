resource "random_pet" "server" {
  length = 2
  prefix = var.environment
}

resource "local_file" "config" {
  count    = var.instance_count
  filename = "${path.module}/output/server-${count.index}.conf"
  content  = "SERVER=${random_pet.server.id}-${count.index}\nENV=${var.environment}\nOWNER=${var.owner}"
}

output "server_name" {
  value = random_pet.server.id
}

output "config_files" {
  value = local_file.config[*].filename
}
