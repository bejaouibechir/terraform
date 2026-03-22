# Terraform Refresh

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Commande Terraform *`refresh`*

- La commande *`terraform refresh`* est utilisée pour **mettre à jour le fichier state de votre projet Terraform (état stocké) avec l'état réel de l'infrastructure**.
- Lorsque vous exécutez la commande *`terraform refresh`*, Terraform **interroge l'état réel** de vos resources et **le compare avec le fichier state** qu'il maintient localement.
- La commande *`terraform refresh`* **synchronise le state Terraform avec l'état réel de vos resources**.

### Que se passe-t-il lors de l'exécution de la commande *`terraform refresh`* ?

1. **Interrogation des Resources** : Terraform communique avec les providers pour récupérer l'état courant de toutes les resources définies dans votre configuration.

2. **Comparaison avec le Fichier State** : Il compare l'état courant des resources avec l'état stocké dans le fichier state.

3. **Mise à Jour du Fichier State** : Toute différence constatée entre l'état réel et le fichier state est mise à jour dans le fichier state.

4. **Ne Modifie pas l'Infrastructure** : Contrairement à `terraform apply`, `terraform refresh` **met uniquement à jour le fichier state** et **n'apporte aucune modification** aux resources réelles.

### Quand utiliser la commande *`terraform refresh`*

- **Après des Modifications Externes** : Utilisez *`terraform refresh`* lorsque vous suspectez que des modifications ont été apportées à vos resources en dehors de Terraform (drift).

- **Avant d'Appliquer des Changements** : Il est souvent conseillé d'exécuter *`terraform refresh`* avant `terraform apply` pour s'assurer que votre configuration est basée sur les informations les plus récentes.

## Exemple Pratique — Détecter un Drift

Ce module crée un fichier de configuration via Terraform. Nous allons ensuite **modifier manuellement** ce fichier pour simuler un drift (dérive de l'état), puis observer le comportement de `terraform plan` et `terraform refresh`.

### Structure des Fichiers

```
14-Terraform-Refresh/
├── 00_provider.tf
├── 01_backend.tf
├── 02_variables.tf
├── 03_vpc.tf
└── output/
    └── infra.conf    (créé par Terraform)
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

[01_backend.tf](./01_backend.tf)

```hcl
terraform {
  # Backend local — state stocké dans terraform.tfstate
  backend "local" {
    path = "terraform.tfstate"
  }
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

[03_vpc.tf](./03_vpc.tf)

```hcl
resource "random_pet" "infra_name" {
  length = 2
  prefix = var.environment
}

# Ce fichier sera créé par Terraform puis modifié manuellement
# pour démontrer terraform refresh (détection de dérive)
resource "local_file" "infra_config" {
  filename = "${path.module}/output/infra.conf"
  content  = <<-EOT
    # Configuration gérée par Terraform
    # OWNER=${var.owner}
    # ENV=${var.environment}
    INFRA_NAME=${random_pet.infra_name.id}
    STATUS=active
    MANAGED_BY=terraform
  EOT
}
```

## Exécution Pas à Pas

### Étape 1 — Déploiement initial

```shell
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply -auto-approve
```

<details>
<summary><i>terraform apply</i></summary>

```shell
$ terraform apply -auto-approve

random_pet.infra_name: Creating...
random_pet.infra_name: Creation complete after 0s [id=dev-bold-gecko]
local_file.infra_config: Creating...
local_file.infra_config: Creation complete after 0s [id=...]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

</details>

Le fichier `output/infra.conf` créé contient :

```
# Configuration gérée par Terraform
# OWNER=Venkatesh
# ENV=dev
INFRA_NAME=dev-bold-gecko
STATUS=active
MANAGED_BY=terraform
```

### Étape 2 — Modifier manuellement le fichier (simulation du drift)

Ouvrez `output/infra.conf` dans un éditeur et ajoutez une ligne :

```
INFRA_NAME=dev-bold-gecko
STATUS=active
MANAGED_BY=terraform
MANUAL_CHANGE=true
```

### Étape 3 — `terraform plan` détecte le drift

```shell
$ terraform plan

random_pet.infra_name: Refreshing state... [id=dev-bold-gecko]
local_file.infra_config: Refreshing state... [id=...]

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # local_file.infra_config will be updated in-place
  ~ resource "local_file" "infra_config" {
      ~ content = <<-EOT
          # Configuration gérée par Terraform
          # OWNER=Venkatesh
          # ENV=dev
          INFRA_NAME=dev-bold-gecko
          STATUS=active
          MANAGED_BY=terraform
        + MANUAL_CHANGE=true
        EOT
          filename = "./output/infra.conf"
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Terraform détecte que le fichier a été modifié manuellement et propose de **supprimer les modifications** pour revenir à l'état désiré.

### Étape 4 — `terraform refresh` resynchronise le state

```shell
$ terraform refresh

random_pet.infra_name: Refreshing state... [id=dev-bold-gecko]
local_file.infra_config: Refreshing state... [id=...]
```

`terraform refresh` met à jour le **state file** pour refléter le fichier tel qu'il existe réellement sur le disque (avec `MANUAL_CHANGE=true`).

### Étape 5 — Comportement après `terraform refresh`

- **`terraform refresh`** a mis à jour le state avec l'état actuel du fichier.
- Mais votre **code Terraform** (`03_vpc.tf`) ne contient toujours pas `MANUAL_CHANGE=true`.
- Donc `terraform plan` **détectera toujours le drift** et proposera de supprimer la modification manuelle.

```shell
$ terraform plan
# Résultat : Terraform propose toujours de supprimer MANUAL_CHANGE=true
Plan: 0 to add, 1 to change, 0 to destroy.
```

### Étape 6 — Deux choix face au drift

**Choix 1 : Supprimer les modifications manuelles** (laisser Terraform gérer)

```shell
terraform apply -auto-approve
# Terraform recrée le fichier tel que défini dans le code
```

**Choix 2 : Conserver les modifications manuelles** (mettre à jour le code)

Modifiez `03_vpc.tf` pour inclure le changement :

```hcl
resource "local_file" "infra_config" {
  filename = "${path.module}/output/infra.conf"
  content  = <<-EOT
    # Configuration gérée par Terraform
    # OWNER=${var.owner}
    # ENV=${var.environment}
    INFRA_NAME=${random_pet.infra_name.id}
    STATUS=active
    MANAGED_BY=terraform
    MANUAL_CHANGE=true
  EOT
}
```

Puis :

```shell
$ terraform plan

No changes. Your infrastructure matches the configuration.
```

### Résumé

| Situation | Commande | Effet |
|---|---|---|
| Drift détecté | `terraform plan` | Affiche les différences entre state et code |
| Resynchroniser le state | `terraform refresh` | Met à jour le state file avec l'état réel |
| Supprimer le drift | `terraform apply` | Recrée les resources selon le code |
| Conserver le drift | Modifier le code + `terraform apply` | Aligne le code sur l'état réel |

- **Remarque** : La commande *`terraform refresh`* **met uniquement à jour le fichier state** et **n'importe pas réellement les nouveaux changements dans le code existant**.

### Nettoyage

```shell
terraform destroy -auto-approve
```

## Références :

- [Terraform Refresh](https://developer.hashicorp.com/terraform/cli/commands/refresh)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
