# Meta-argument FOR_EACH — map
# Crée un fichier de configuration par environnement
# Équivaut à créer des S3 buckets par environnement avec for_each + map

resource "local_file" "bucket_config" {
  for_each = {
    dev = "venkat-app-log-dev"
    uat = "venkat-app-log-uat"
    pre = "venkat-app-log-pre"
    prd = "venkat-app-log-prd"
  }

  filename = "${path.module}/output/${each.key}-bucket.conf"
  content  = <<-EOT
    BUCKET_NAME=${each.value}
    ENVIRONMENT=${each.key}
    REGION=us-east-1
  EOT
}

output "bucket_configs" {
  description = "Chemins des fichiers de configuration créés"
  value       = { for k, v in local_file.bucket_config : k => v.filename }
}
