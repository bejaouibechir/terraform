# Commande Terraform Show

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Commande *`terraform show`*

- La commande *`terraform show`* est utilisée pour **afficher une représentation lisible par l'humain du state Terraform ou d'un fichier de plan**.
- Elle permet d'**inspecter l'état courant** de votre infrastructure gérée par Terraform ou de **visualiser le contenu d'un fichier de plan** avant de l'appliquer.
- *`terraform show`* est utile pour **vérifier l'état actuel des resources** sans avoir à ouvrir directement le fichier `terraform.tfstate`.

## Utilisation

- *`terraform show`* : Affiche le state courant de l'infrastructure
- *`terraform show <fichier-plan>`* : Affiche le contenu d'un fichier de plan spécifique (généré avec `terraform plan -out=<fichier-plan>`)

**Syntaxe** :

```shell
# Afficher le state courant
terraform show

# Afficher un fichier de plan spécifique
terraform show <fichier-plan>
```

## Exemple Pratique

Ce module crée un nom aléatoire (`random_pet`), un ID hexadécimal (`random_id`) et un fichier de configuration JSON (`local_file`), puis démontre l'utilisation de `terraform show` pour inspecter l'état.

### Structure des Fichiers

```
13-Terraform-Show/
├── 00_provider.tf
├── 01_variables.tf
├── 02_resources.tf
├── 03_outputs.tf
└── output/
    └── infra.json    (créé par Terraform)
```

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "random" {}
provider "local" {}
```

[01_variables.tf](./01_variables.tf)

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

[02_resources.tf](./02_resources.tf)

```hcl
resource "random_pet" "name" {
  length = 2
  prefix = var.environment
}

resource "random_id" "id" {
  byte_length = 4
}

resource "local_file" "config" {
  filename = "${path.module}/output/infra.json"
  content = jsonencode({
    name        = random_pet.name.id
    id          = random_id.id.hex
    environment = var.environment
    owner       = var.owner
  })
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
output "resource_name" {
  description = "Nom de la ressource générée"
  value       = random_pet.name.id
}

output "resource_id" {
  description = "ID unique de la ressource"
  value       = random_id.id.hex
}

output "config_path" {
  description = "Chemin du fichier de configuration"
  value       = local_file.config.filename
}
```

## Exécution Pas à Pas

1. ***`terraform init`*** : *Initialiser* Terraform
2. ***`terraform validate`*** : *Valider* le code Terraform
3. ***`terraform fmt`*** : *Formater* le code Terraform
4. ***`terraform plan`*** : *Réviser* le plan Terraform
5. ***`terraform apply`*** : *Créer* les Resources
6. ***`terraform show`*** : *Inspecter* l'état courant

<details>
<summary><i>terraform apply</i></summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_id.id will be created
  + resource "random_id" "id" {
      + byte_length = 4
      + hex         = (known after apply)
      + id          = (known after apply)
    }

  # random_pet.name will be created
  + resource "random_pet" "name" {
      + id     = (known after apply)
      + length = 2
      + prefix = "dev"
    }

  # local_file.config will be created
  + resource "local_file" "config" {
      + filename = "./output/infra.json"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

random_id.id: Creating...
random_id.id: Creation complete after 0s [id=c4a1e37f]
random_pet.name: Creating...
random_pet.name: Creation complete after 0s [id=dev-noble-crane]
local_file.config: Creating...
local_file.config: Creation complete after 0s [id=...]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

config_path   = "./output/infra.json"
resource_id   = "c4a1e37f"
resource_name = "dev-noble-crane"
```

</details>

### Utilisation de `terraform show`

Après l'apply, exécutez `terraform show` pour inspecter le state courant :

```shell
$ terraform show

# local_file.config:
resource "local_file" "config" {
    content              = jsonencode(...)
    directory_permission = "0777"
    file_permission      = "0777"
    filename             = "./output/infra.json"
    id                   = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
}

# random_id.id:
resource "random_id" "id" {
    b64_std     = "xKHjfw=="
    b64_url     = "xKHjfw"
    byte_length = 4
    dec         = "3300435839"
    hex         = "c4a1e37f"
    id          = "xKHjfw"
}

# random_pet.name:
resource "random_pet" "name" {
    id        = "dev-noble-crane"
    length    = 2
    prefix    = "dev"
    separator = "-"
}
```

### Générer et inspecter un fichier de plan

```shell
# Générer un fichier de plan
terraform plan -out=monplan.tfplan

# Inspecter le fichier de plan
terraform show monplan.tfplan
```

<details>
<summary><i>terraform show monplan.tfplan</i></summary>

```shell
$ terraform show monplan.tfplan

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_id.id will be created
  + resource "random_id" "id" {
      + byte_length = 4
      + hex         = (known after apply)
    }

  # random_pet.name will be created
  + resource "random_pet" "name" {
      + id     = (known after apply)
      + length = 2
      + prefix = "dev"
    }

  # local_file.config will be created
  + resource "local_file" "config" {
      + filename = "./output/infra.json"
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```

</details>

### Nettoyage

```shell
terraform destroy -auto-approve
```

## Références :

- [Terraform Show](https://developer.hashicorp.com/terraform/cli/commands/show)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
