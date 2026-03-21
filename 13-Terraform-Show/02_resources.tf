resource "random_pet" "name" {
  length = 2
  prefix = var.environment
}

resource "random_id" "id" {
  byte_length = 4
}

resource "local_file" "config" {
  filename = "${path.module}/output/infra.json"
  content = jsonencode({
    name        = random_pet.name.id
    id          = random_id.id.hex
    environment = var.environment
    owner       = var.owner
  })
}
