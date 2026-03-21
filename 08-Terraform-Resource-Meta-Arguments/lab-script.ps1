# ######################################################
# Lab : 08 - Terraform Resource Meta-Arguments
# Ce script itère sur chaque sous-lab indépendamment
# ######################################################

function Run-Lab {
  param(
    [string]$Dir,
    [string]$Name
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

  Write-Host "--- terraform plan ---" -ForegroundColor Cyan
  terraform plan

  Write-Host "--- terraform apply ---" -ForegroundColor Cyan
  terraform apply -auto-approve

  Write-Host "--- terraform state list ---" -ForegroundColor Cyan
  terraform state list

  Write-Host "--- terraform destroy ---" -ForegroundColor Cyan
  terraform destroy -auto-approve

  Write-Host "Lab '$Name' terminé." -ForegroundColor Green
  Set-Location $PSScriptRoot
}

$BaseDir = $PSScriptRoot

Run-Lab "$BaseDir\08-01-count"                              "08-01 : count"
Run-Lab "$BaseDir\08-02-for_each\01-for_each-map"           "08-02a : for_each (map)"
Run-Lab "$BaseDir\08-02-for_each\02-for_each-set"           "08-02b : for_each (set)"
Run-Lab "$BaseDir\08-03-depends_on"                         "08-03 : depends_on"
Run-Lab "$BaseDir\08-04-provider"                           "08-04 : provider"
Run-Lab "$BaseDir\08-05-lifecycle\01-create_before_destroy" "08-05a : lifecycle - create_before_destroy"

Write-Host ""
Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Tous les labs 08 terminés avec succès !" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta
