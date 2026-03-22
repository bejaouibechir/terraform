# Meta-argument FOR_EACH — set
# Crée un fichier de profil par utilisateur
# Équivaut à créer des utilisateurs IAM avec for_each + toset()
# Note : les doublons dans un set sont automatiquement dédupliqués

resource "local_file" "user_profile" {
  for_each = toset(["Amar", "Akbar", "Anthony", "Amar"]) # "Amar" dédupliqué par le set

  filename = "${path.module}/output/${each.key}-profile.conf"
  content  = <<-EOT
    USERNAME=${each.key}
    ROLE=developer
    CREATED=true
  EOT
}

output "user_profiles" {
  description = "Profils utilisateurs créés (doublons supprimés par le set)"
  value       = { for k, v in local_file.user_profile : k => v.filename }
}
