# Outputs Terraform

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

- Dans Terraform, les outputs vous permettent d'**exposer des informations sur votre infrastructure déployée**.
- Les outputs sont utiles pour **obtenir des informations sur votre infrastructure dont vous pourriez avoir besoin ultérieurement**.
- Les valeurs de sortie **peuvent être utilisées comme entrée pour d'autres configurations ou scripts Terraform**.
- Les outputs sont également utiles pour **partager des informations avec votre équipe ou des processus externes**.
- Vous **pouvez définir plusieurs outputs** dans une seule configuration Terraform pour obtenir différentes informations.
- Vous pouvez utiliser un bloc ***`output`*** pour spécifier quelles informations vous souhaitez extraire.

**Syntaxe** :

```hcl
output "nom_local" {
  description = "Description de la valeur exposée"
  value       = type_resource.nom_resource.attribut
}
```

## Types d'Outputs

| Type | Exemple | Description |
|------|---------|-------------|
| **string** | `random_pet.server_name.id` | Chaîne de caractères simple |
| **number** | `random_integer.port.result` | Valeur numérique |
| **string interpolé** | `"http://${...}:${...}"` | URL construite par interpolation |
| **sensitive** | `random_password.api_key.result` | Valeur masquée dans les logs |
| **string multi-lignes** | `tls_private_key.ssh_key.public_key_openssh` | Clé publique SSH |
| **objet** | `{ name = ..., port = ..., ... }` | Structure de données complexe |

## Exemple Pratique

### Structure des Fichiers

```
10-Terraform-Outputs/
├── 00_provider.tf
├── 01_resources.tf
├── 02_variables.tf
├── 03_outputs.tf
└── output/
    └── connection.txt    (créé par Terraform)
```

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "random" {}
provider "tls" {}
provider "local" {}
```

[01_resources.tf](./01_resources.tf)

```hcl
resource "random_pet" "server_name" {
  length = 2
  prefix = "srv"
}

resource "random_integer" "port" {
  min = 8000
  max = 9000
}

resource "random_password" "api_key" {
  length  = 32
  special = false
}

# Génération d'une clé TLS — démontre un output de type objet complexe
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "connection_info" {
  filename = "${path.module}/output/connection.txt"
  content  = <<-EOT
    Serveur  : ${random_pet.server_name.id}
    Port     : ${random_integer.port.result}
    Endpoint : http://${random_pet.server_name.id}:${random_integer.port.result}
  EOT
}
```

[02_variables.tf](./02_variables.tf)

```hcl
variable "environment" {
  description = "Nom de l'environnement"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Nom de l'ingénieur responsable"
  type        = string
  default     = "Venkatesh"
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
# Output simple — string
output "server_name" {
  description = "Nom du serveur généré"
  value       = random_pet.server_name.id
}

# Output numérique
output "server_port" {
  description = "Port d'écoute du serveur"
  value       = random_integer.port.result
}

# Output construit (interpolation)
output "server_endpoint" {
  description = "URL complète du serveur"
  value       = "http://${random_pet.server_name.id}:${random_integer.port.result}"
}

# Output sensible — masqué dans les logs terraform apply
output "api_key" {
  description = "Clé API générée (sensible — masquée dans les logs)"
  value       = random_password.api_key.result
  sensitive   = true
}

# Output de type string multi-lignes (clé publique SSH)
output "ssh_public_key" {
  description = "Clé publique SSH générée par le provider TLS"
  value       = tls_private_key.ssh_key.public_key_openssh
}

# Output de type objet
output "server_info" {
  description = "Informations complètes du serveur (objet)"
  value = {
    name        = random_pet.server_name.id
    port        = random_integer.port.result
    environment = var.environment
    owner       = var.owner
  }
}
```

## Exécution Pas à Pas

1. ***`terraform init`*** : *Initialiser* Terraform
2. ***`terraform validate`*** : *Valider* le code Terraform
3. ***`terraform fmt`*** : *Formater* le code Terraform
4. ***`terraform plan`*** : *Réviser* le plan Terraform
5. ***`terraform apply`*** : *Créer* les Resources

<details>
<summary><i>terraform apply</i></summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_integer.port will be created
  # random_password.api_key will be created
  # random_pet.server_name will be created
  # tls_private_key.ssh_key will be created
  # local_file.connection_info will be created

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + api_key         = (sensitive value)
  + server_endpoint = (known after apply)
  + server_info     = (known after apply)
  + server_name     = (known after apply)
  + server_port     = (known after apply)
  + ssh_public_key  = (known after apply)

random_pet.server_name: Creating...
random_pet.server_name: Creation complete after 0s [id=srv-happy-lemur]
random_integer.port: Creating...
random_integer.port: Creation complete after 0s [id=8472]
random_password.api_key: Creating...
random_password.api_key: Creation complete after 0s [id=none]
tls_private_key.ssh_key: Creating...
tls_private_key.ssh_key: Creation complete after 1s [id=...]
local_file.connection_info: Creating...
local_file.connection_info: Creation complete after 0s [id=...]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

api_key         = <sensitive>
server_endpoint = "http://srv-happy-lemur:8472"
server_info     = {
  "environment" = "dev"
  "name"        = "srv-happy-lemur"
  "owner"       = "Venkatesh"
  "port"        = 8472
}
server_name     = "srv-happy-lemur"
server_port     = 8472
ssh_public_key  = <<EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7... (clé publique RSA 2048 bits)
EOT
```

</details>

### Points clés à observer

- **`api_key`** est marqué `sensitive = true` : sa valeur est remplacée par `<sensitive>` dans la sortie de `terraform apply`. La valeur reste accessible via `terraform output api_key`.
- **`server_info`** est un **objet** : Terraform l'affiche en format multi-lignes avec les types et valeurs.
- **`ssh_public_key`** contient une **chaîne multi-lignes** : la clé publique RSA générée par le provider `tls`.
- **`server_endpoint`** est une **interpolation** : Terraform résout dynamiquement `${random_pet.server_name.id}:${random_integer.port.result}`.

### Afficher un output individuel

```shell
# Afficher la valeur d'un output spécifique
terraform output server_name
terraform output server_port

# Afficher un output sensible
terraform output api_key

# Sortie en JSON (utile pour les scripts)
terraform output -json server_info
```

### Nettoyage

```shell
terraform destroy -auto-approve
```

## Références :

- [Valeurs de Sortie](https://developer.hashicorp.com/terraform/language/values/outputs)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- [Provider tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs)
