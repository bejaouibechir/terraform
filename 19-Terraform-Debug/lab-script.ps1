# ============================================================
# Lab 19 - Terraform Debug
# ============================================================

# Active la journalisation au niveau TRACE (très détaillé)
$env:TF_LOG = "TRACE"
$env:TF_LOG_PATH = "terraform-trace.log"

# Génère des logs TRACE pendant l'initialisation
terraform init

# Génère des logs TRACE pendant la validation
terraform validate

# Génère des logs TRACE pendant le plan
terraform plan

# Génère des logs TRACE pendant l'apply
terraform apply -auto-approve

# Affiche le nombre total de lignes dans le fichier de log
(Get-Content terraform-trace.log).Count

# Affiche les 20 premières lignes du log
Get-Content terraform-trace.log | Select-Object -First 20

# Recherche les appels API dans les logs
Select-String -Path terraform-trace.log -Pattern "POST|GET|PUT" | Select-Object -First 10

# Passe le niveau de log à INFO (moins verbeux que TRACE)
$env:TF_LOG = "INFO"
terraform refresh

# Désactive complètement la journalisation
Remove-Item Env:TF_LOG -ErrorAction SilentlyContinue
Remove-Item Env:TF_LOG_PATH -ErrorAction SilentlyContinue

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve

# Supprime les fichiers générés pendant le lab
Remove-Item -Recurse -Force .terraform* -ErrorAction SilentlyContinue
Remove-Item -Force terraform.tfstate* -ErrorAction SilentlyContinue
Remove-Item -Force terraform-trace.log -ErrorAction SilentlyContinue
