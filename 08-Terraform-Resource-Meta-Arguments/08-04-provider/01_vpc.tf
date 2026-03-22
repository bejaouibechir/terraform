# Meta-argument PROVIDER
# Chaque ressource cible explicitement un provider aliasé
# Simule : créer des VPCs dans deux régions AWS différentes

resource "local_file" "europe_config" {
  provider = local.project-europe
  filename = "${path.module}/output/europe/infra.conf"
  content  = "REGION=eu-west-1\nENV=europe\nVPC_CIDR=10.1.0.0/16"
}

resource "local_file" "asia_config" {
  provider = local.project-asia
  filename = "${path.module}/output/asia/infra.conf"
  content  = "REGION=ap-south-1\nENV=asia\nVPC_CIDR=10.2.0.0/16"
}

output "europe_config_path" {
  value = local_file.europe_config.filename
}

output "asia_config_path" {
  value = local_file.asia_config.filename
}
