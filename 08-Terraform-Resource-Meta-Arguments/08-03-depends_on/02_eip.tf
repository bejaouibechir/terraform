# Meta-argument DEPENDS_ON
resource "local_file" "dns_record" {
  filename   = "${path.module}/output/dns.conf"
  content    = "DNS_ENTRY=${random_pet.server.id}.example.com\nPOINTS_TO=server"
  depends_on = [local_file.server_config]
}

output "server_name" {
  value = random_pet.server.id
}

output "dns_entry" {
  value = "${random_pet.server.id}.example.com"
}
