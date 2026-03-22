# Meta-argument FOR_EACH avec un set de strings
# Équivaut à créer un Security Group par environnement

locals {
  environments = toset(["dev", "staging", "prod"])

  servers = {
    web = { port = 80,   env = "prod"    }
    api = { port = 8080, env = "staging" }
    db  = { port = 5432, env = "prod"    }
  }
}

# FOR_EACH sur un set
resource "local_file" "env_config" {
  for_each = local.environments
  filename = "${path.module}/output/${each.key}/config.conf"
  content  = "ENV=${each.key}\nMANAGED_BY=terraform"
}

# FOR_EACH sur une map
resource "local_file" "server_config" {
  for_each = local.servers
  filename = "${path.module}/output/servers/${each.key}.conf"
  content  = "SERVER=${each.key}\nPORT=${each.value.port}\nENV=${each.value.env}"
}

output "env_configs" {
  description = "Fichiers créés par for_each (set)"
  value       = { for k, v in local_file.env_config : k => v.filename }
}

output "server_configs" {
  description = "Fichiers créés par for_each (map)"
  value       = { for k, v in local_file.server_config : k => v.filename }
}
