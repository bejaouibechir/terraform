# Variables Terraform — Fichiers `.tfvars` multiples avec `-var-file`

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Sélectionner un fichier de variables avec `-var-file`

Lorsque vous gérez plusieurs environnements (`dev`, `prod`...), il est pratique de disposer d'un fichier `.tfvars` **par environnement** et de sélectionner le bon au moment de l'exécution avec l'option `-var-file`.

- Contrairement à `terraform.tfvars` (lu automatiquement), les fichiers avec un nom arbitraire doivent être **explicitement passés** via `-var-file`.
- Cette approche permet de maintenir **un seul code Terraform** et plusieurs jeux de valeurs.
- Les fichiers peuvent avoir n'importe quel nom, mais la convention est `<env>.tfvars`.

**Syntaxe :**

```bash
terraform plan  -var-file="<fichier>.tfvars"
terraform apply -var-file="<fichier>.tfvars"
```

---

## Fichiers du lab

**`00_provider.tf`**

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

**`01_ec2.tf`**

```hcl
resource "random_pet" "server" {
  length = 2
  prefix = var.environment
}

resource "local_file" "config" {
  filename = "${path.module}/output/server.conf"
  content  = "SERVER=${random_pet.server.id}\nENV=${var.environment}\nOWNER=${var.owner}"
}

output "server_name" { value = random_pet.server.id }
```

**`02_variables.tf`**

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

variable "instance_count" {
  description = "Nombre d'instances"
  type        = number
  default     = 1
}
```

---

## Les fichiers `.tfvars` par environnement

**`dev.tfvars`**

```hcl
environment    = "dev"
owner          = "DevTeam"
instance_count = 1
```

**`prod.tfvars`**

```hcl
environment    = "prod"
owner          = "OpsTeam"
instance_count = 3
```

Chaque fichier définit un jeu complet de valeurs adapté à son environnement cible. Les valeurs `default` de `02_variables.tf` sont entièrement écrasées.

---

## Comparaison des environnements

| Variable         | `dev.tfvars` | `prod.tfvars` |
| ---------------- | ------------ | ------------- |
| `environment`    | `"dev"`      | `"prod"`      |
| `owner`          | `"DevTeam"`  | `"OpsTeam"`   |
| `instance_count` | `1`          | `3`           |

---

## Utilisation

### Déploiement en environnement de développement

```bash
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

### Déploiement en environnement de production

```bash
terraform plan  -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

### Combiner `-var-file` et `-var`

Il est possible de passer d'abord un fichier puis de surcharger une valeur individuelle. La valeur `-var` a toujours la **priorité la plus haute**.

```bash
terraform plan -var-file="prod.tfvars" -var="owner=Alice"
# → owner = "Alice"  ← -var écrase prod.tfvars
```

### Sauvegarder et réutiliser un plan

```bash
terraform plan -var-file="prod.tfvars" -out=prod.plan
terraform apply prod.plan
```

---

## Sortie de `terraform plan -var-file="dev.tfvars"`

```
Terraform will perform the following actions:

  # random_pet.server will be created
  + resource "random_pet" "server" {
      + id     = (known after apply)
      + length = 2
      + prefix = "dev"
    }

  # local_file.config will be created
  + resource "local_file" "config" {
      + content  = (known after apply)
      + filename = "./output/server.conf"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

## Sortie de `terraform plan -var-file="prod.tfvars"`

```
Terraform will perform the following actions:

  # random_pet.server will be created
  + resource "random_pet" "server" {
      + id     = (known after apply)
      + length = 2
      + prefix = "prod"    # ← valeur du prod.tfvars
    }

  # local_file.config will be created
  + resource "local_file" "config" {
      + content  = (known after apply)
      + filename = "./output/server.conf"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

---

## Commandes Terraform

```bash
terraform init

# Environnement dev
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Environnement prod
terraform plan  -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"

terraform destroy -var-file="dev.tfvars"
```

---

## Références

- [Fichiers de définition de variables (.tfvars)](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
- [Option `-var-file`](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)
