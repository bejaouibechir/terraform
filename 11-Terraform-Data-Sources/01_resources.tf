resource "random_id" "instance_id" {
  byte_length = 4
}

# Utilise les données récupérées par le data source HTTP
resource "local_file" "instance_info" {
  filename = "${path.module}/output/instance_info.json"
  content = jsonencode({
    instance_id    = random_id.instance_id.hex
    environment    = var.environment
    public_ip      = jsondecode(data.http.public_ip.response_body).ip
    existing_config = jsondecode(data.local_file.existing_config.content)
  })
}
