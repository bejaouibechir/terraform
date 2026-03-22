# Variable de type list — for_each sur une liste de serveurs
resource "local_file" "server" {
  for_each = toset(var.server_names)
  filename = "${path.module}/output/${each.key}.conf"
  content  = "SERVER=${each.key}\nENV=${var.environment}"
}

output "server_files" {
  value = { for k, v in local_file.server : k => v.filename }
}
