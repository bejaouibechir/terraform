# ============================================================
# Lab 08 - Terraform Resource Meta-Arguments
# Exécuter depuis : 08-Terraform-Resource-Meta-Arguments\
# ============================================================

# ── 08-01 : count ───────────────────────────────────────────
Set-Location 08-01-count
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
# Vérifiez les ressources créées avec count (plusieurs instances)
terraform state list
terraform destroy -auto-approve
Set-Location ..

# ── 08-02a : for_each (map) ─────────────────────────────────
Set-Location 08-02-for_each\01-for_each-map
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
# Vérifiez les ressources créées avec for_each sur une map
terraform state list
terraform destroy -auto-approve
Set-Location ..\..

# ── 08-02b : for_each (set) ─────────────────────────────────
Set-Location 08-02-for_each\02-for_each-set
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
# Vérifiez les ressources créées avec for_each sur un set
terraform state list
terraform destroy -auto-approve
Set-Location ..\..

# ── 08-03 : depends_on ──────────────────────────────────────
Set-Location 08-03-depends_on
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform state list
terraform destroy -auto-approve
Set-Location ..

# ── 08-04 : provider ────────────────────────────────────────
Set-Location 08-04-provider
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform state list
terraform destroy -auto-approve
Set-Location ..

# ── 08-05a : lifecycle - create_before_destroy ──────────────
Set-Location 08-05-lifecycle\01-create_before_destroy
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform state list
terraform destroy -auto-approve
Set-Location ..\..
