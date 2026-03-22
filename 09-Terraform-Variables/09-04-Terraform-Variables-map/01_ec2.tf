# Variable de type map — accès par clé
resource "local_file" "server" {
  for_each = var.servers
  filename = "${path.module}/output/${each.key}.conf"
  content  = "SERVER=${each.key}\nPORT=${each.value.port}\nENV=${each.value.env}"
}

output "server_configs" {
  value = { for k, v in local_file.server : k => v.filename }
}
