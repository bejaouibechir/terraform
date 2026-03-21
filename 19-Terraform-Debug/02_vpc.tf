resource "random_pet" "resource_name" {
  length = 2
  prefix = var.environment
}

resource "random_id" "resource_id" {
  byte_length = 4
}

resource "local_file" "debug_output" {
  filename = "${path.module}/output/debug.txt"
  content  = "RESOURCE=${random_pet.resource_name.id}\nID=${random_id.resource_id.hex}\nOWNER=${var.owner}"
}
