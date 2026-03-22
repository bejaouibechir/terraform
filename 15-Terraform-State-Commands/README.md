# Commandes State Terraform

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

- Les commandes *state* Terraform sont utilisées
  - Pour **inspecter**, **modifier** et **gérer** le state Terraform
  - Pour **suivre l'état** de votre infrastructure
  - **Effectuer des modifications sécurisées** au fichier state Terraform

## Liste des Commandes State Terraform

### Inspection du State

1. *`terraform state list`* : Liste toutes les resources dans le state Terraform.

2. *`terraform state show`* : Affiche les attributs d'une resource spécifique dans le state Terraform.

3. *`terraform state refresh`* : Met à jour le fichier state Terraform avec l'état réel de l'infrastructure gérée.

4. *`terraform state version`* : Affiche la version du format du fichier state Terraform.

### Déplacement de Resources

5. *`terraform state mv`* : Déplace un élément dans le state Terraform d'un ID à un autre. Utile pour renommer des resources.

6. *`terraform state rm`* : Supprime une instance de resource du state Terraform. À utiliser avec précaution, car cela ne détruit pas l'infrastructure associée.

7. *`terraform state replace-provider`* : Remplace un provider dans le state Terraform. Utile pour modifier les configurations de provider.

### Reprise après Sinistre

8. *`terraform state pull`* : Récupère l'état courant et l'affiche sur stdout.

9. *`terraform state push`* : Utilisé pour télécharger un fichier state local vers un backend de state distant.

10. *`terraform force-unlock`* : Libère un verrou bloqué sur le fichier state.

### Forcer la Recréation

11. *`terraform taint`* : Marque une instance de resource comme "tainted" (altérée), la forçant à être détruite et recréée lors du prochain apply.

12. *`terraform untaint`* : Supprime l'état "tainted" d'une instance de resource.

## Exemple Pratique

Ce module crée plusieurs resources pour démontrer les commandes state : deux noms aléatoires (`random_pet`), un ID réseau (`random_id`) et deux fichiers de configuration (`local_file`).

### Structure des Fichiers

```
15-Terraform-State-Commands/
├── 00_provider.tf
├── 01_variables.tf
├── 02_vpc.tf
├── 03_outputs.tf
└── output/
    ├── server.conf      (créé par Terraform)
    └── database.conf    (créé par Terraform)
```

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "local" {}
provider "random" {}
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

[02_vpc.tf](./02_vpc.tf)

```hcl
# Plusieurs ressources pour démontrer les commandes state
# terraform state list, show, mv, rm

resource "random_pet" "server" {
  length = 2
  prefix = var.environment
}

resource "random_pet" "database" {
  length = 2
  prefix = "db"
}

resource "random_id" "network_id" {
  byte_length = 4
}

resource "local_file" "server_config" {
  filename = "${path.module}/output/server.conf"
  content  = "SERVER=${random_pet.server.id}\nNETWORK_ID=${random_id.network_id.hex}"
}

resource "local_file" "db_config" {
  filename = "${path.module}/output/database.conf"
  content  = "DATABASE=${random_pet.database.id}\nNETWORK_ID=${random_id.network_id.hex}"
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
output "server_name" {
  description = "Nom du serveur"
  value       = random_pet.server.id
}

output "database_name" {
  description = "Nom de la base de données"
  value       = random_pet.database.id
}

output "network_id" {
  description = "ID du réseau"
  value       = random_id.network_id.hex
}
```

## Exécution Pas à Pas

### Étape 1 — Déploiement initial

```shell
terraform init
terraform apply -auto-approve
```

<details>
<summary><i>terraform apply</i></summary>

```shell
$ terraform apply -auto-approve

random_id.network_id: Creating...
random_id.network_id: Creation complete after 0s [id=f3a8c21d]
random_pet.server: Creating...
random_pet.server: Creation complete after 0s [id=dev-calm-moose]
random_pet.database: Creating...
random_pet.database: Creation complete after 0s [id=db-lazy-wolf]
local_file.server_config: Creating...
local_file.server_config: Creation complete after 0s [id=...]
local_file.db_config: Creating...
local_file.db_config: Creation complete after 0s [id=...]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

database_name = "db-lazy-wolf"
network_id    = "f3a8c21d"
server_name   = "dev-calm-moose"
```

</details>

### Étape 2 — `terraform state list`

Liste toutes les resources enregistrées dans le state :

```shell
$ terraform state list

local_file.db_config
local_file.server_config
random_id.network_id
random_pet.database
random_pet.server
```

### Étape 3 — `terraform state show`

Affiche tous les attributs d'une resource spécifique :

```shell
$ terraform state show random_pet.server

# random_pet.server:
resource "random_pet" "server" {
    id        = "dev-calm-moose"
    length    = 2
    prefix    = "dev"
    separator = "-"
}
```

```shell
$ terraform state show random_id.network_id

# random_id.network_id:
resource "random_id" "network_id" {
    b64_std     = "86jCHQ=="
    b64_url     = "86jCHQ"
    byte_length = 4
    dec         = "4090134045"
    hex         = "f3a8c21d"
    id          = "86jCHQ"
}
```

```shell
$ terraform state show local_file.server_config

# local_file.server_config:
resource "local_file" "server_config" {
    content              = "SERVER=dev-calm-moose\nNETWORK_ID=f3a8c21d"
    directory_permission = "0777"
    file_permission      = "0777"
    filename             = "./output/server.conf"
    id                   = "da39..."
}
```

### Étape 4 — `terraform state mv`

Renomme une resource dans le state **sans la détruire ni la recréer**. Utile lors d'un refactoring du code.

```shell
# Renommer random_pet.server en random_pet.web_server dans le state
$ terraform state mv random_pet.server random_pet.web_server

Move "random_pet.server" to "random_pet.web_server"
Successfully moved 1 object(s).
```

> **Attention** : Après un `state mv`, vous devez également renommer la resource dans votre fichier `.tf` pour éviter que Terraform ne tente de créer/détruire des resources lors du prochain `plan`.

### Étape 5 — `terraform state rm`

Supprime une resource du state **sans la détruire physiquement**. La resource continue d'exister mais Terraform ne la gère plus.

```shell
# Retirer local_file.db_config du state (le fichier database.conf n'est PAS supprimé)
$ terraform state rm local_file.db_config

Removed local_file.db_config
Successfully removed 1 resource instance(s).
```

Vérification après suppression :

```shell
$ terraform state list

local_file.server_config
random_id.network_id
random_pet.database
random_pet.server
# local_file.db_config n'apparaît plus dans le state
```

### Nettoyage

```shell
terraform destroy -auto-approve
```

## Références :

- [Commandes State Terraform](https://developer.hashicorp.com/terraform/cli/state)
- [Inspection du State](https://developer.hashicorp.com/terraform/cli/state/inspect)
- [Déplacement de Resources](https://developer.hashicorp.com/terraform/cli/state/move)
- [Reprise après Sinistre](https://developer.hashicorp.com/terraform/cli/state/recover)
