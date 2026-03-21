# ######################################################
# Lab : 09 - Terraform Variables
# Ce script itère sur chaque sous-lab indépendamment
# ######################################################

function Run-Lab {
  param(
    [string]$Dir,
    [string]$Name,
    [string]$ExtraArgs = ""
  )
  Write-Host ""
  Write-Host "======================================================" -ForegroundColor Magenta
  Write-Host "  LAB : $Name" -ForegroundColor Magenta
  Write-Host "  Répertoire : $Dir" -ForegroundColor Magenta
  Write-Host "======================================================" -ForegroundColor Magenta

  Set-Location $Dir

  Write-Host "--- terraform init ---" -ForegroundColor Cyan
  terraform init -upgrade

  Write-Host "--- terraform fmt ---" -ForegroundColor Cyan
  terraform fmt

  Write-Host "--- terraform validate ---" -ForegroundColor Cyan
  terraform validate

  Write-Host "--- terraform plan $ExtraArgs ---" -ForegroundColor Cyan
  Invoke-Expression "terraform plan $ExtraArgs"

  Write-Host "--- terraform apply $ExtraArgs ---" -ForegroundColor Cyan
  Invoke-Expression "terraform apply -auto-approve $ExtraArgs"

  Write-Host "--- terraform destroy $ExtraArgs ---" -ForegroundColor Cyan
  Invoke-Expression "terraform destroy -auto-approve $ExtraArgs"

  Write-Host "Lab '$Name' terminé." -ForegroundColor Green
  Set-Location $PSScriptRoot
}

$BaseDir = $PSScriptRoot

Run-Lab "$BaseDir"                                            "09 : Variables (défaut)"
Run-Lab "$BaseDir\09-01-Terraform-Variables-tfvars"          "09-01 : Variables tfvars"
Run-Lab "$BaseDir\09-02-Terraform-Variables-tfvars-var-file" "09-02 : Variables var-file" "-var-file=dev.tfvars"
Run-Lab "$BaseDir\09-03-Terraform-Variables-list"            "09-03 : Variables list"
Run-Lab "$BaseDir\09-04-Terraform-Variables-map"             "09-04 : Variables map"
Run-Lab "$BaseDir\09-05-Custom-Validation-Rules"             "09-05 : Custom Validation Rules"
Run-Lab "$BaseDir\09-06-Sensitive-Variables"                 "09-06 : Sensitive Variables"

Write-Host ""
Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Tous les labs 09 terminés avec succès !" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta
