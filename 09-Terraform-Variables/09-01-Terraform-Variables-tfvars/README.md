# Variables Terraform — Fichier `terraform.tfvars`

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Surcharge des valeurs `default` avec le fichier `terraform.tfvars`

Dans Terraform, vous pouvez personnaliser vos configurations sans modifier le code source en utilisant un fichier **`terraform.tfvars`**.

- Le fichier `terraform.tfvars` permet de définir des valeurs personnalisées pour vos variables Terraform.
- Lorsque vous exécutez des commandes Terraform, il **lit automatiquement** `terraform.tfvars` et charge les variables présentes dans ce fichier en remplaçant les valeurs par défaut définies dans `02_variables.tf`.
- Le nom du fichier doit être exactement **`terraform.tfvars`**.
- Vous pouvez également utiliser **`terraform.tfvars.json`** — les fichiers dont les noms se terminent par `.json` sont analysés comme des objets JSON, les propriétés de l'objet racine correspondant aux noms des variables.

**Syntaxe :**

```hcl
nom_variable = "nouvelle_valeur"
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

`random_pet` génère un nom de serveur aléatoire préfixé par la valeur de `var.environment`. `local_file` écrit un fichier de configuration contenant ce nom, l'environnement et le propriétaire.

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

Trois variables sont définies, chacune avec une valeur `default` :

1. `environment` — environnement cible (par défaut : `"dev"`)
2. `owner` — propriétaire des ressources (par défaut : `"Venkatesh"`)
3. `instance_count` — nombre de fichiers à générer (par défaut : `1`)

---

## Le fichier `terraform.tfvars`

Le fichier `terraform.tfvars` surcharge les valeurs par défaut déclarées dans `02_variables.tf` :

**`terraform.tfvars`**

```hcl
environment    = "staging"
owner          = "Alice"
instance_count = 2
```

Ici, les trois valeurs par défaut sont remplacées :

- `environment` passe de `"dev"` à `"staging"`
- `owner` passe de `"Venkatesh"` à `"Alice"`
- `instance_count` passe de `1` à `2`

---

## Priorité de chargement

| Priorité | Source                  | Exemple                         |
| -------- | ----------------------- | ------------------------------- |
| **5** *(haute)* | `-var` ligne de commande | `terraform plan -var="owner=Bob"` |
| **4**    | `*.auto.tfvars`         | `prod.auto.tfvars`              |
| **3**    | `terraform.tfvars.json` | `{ "owner": "Bob" }`            |
| **2**    | `terraform.tfvars`      | `owner = "Bob"`                 |
| **1** *(faible)* | `TF_VAR_` env vars | `export TF_VAR_owner=Bob`      |

> `terraform.tfvars` est automatiquement lu. Pour un autre nom de fichier, utilisez `-var-file` (voir le module 09-02).

---

## Commandes Terraform

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply     # confirmer avec yes
terraform destroy   # confirmer avec yes
```

### Sortie de `terraform plan` (avec `terraform.tfvars`)

```
Terraform will perform the following actions:

  # random_pet.server will be created
  + resource "random_pet" "server" {
      + id     = (known after apply)
      + length = 2
      + prefix = "staging"
    }

  # local_file.config will be created
  + resource "local_file" "config" {
      + content  = (known after apply)
      + filename = "./output/server.conf"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

> Terraform utilise `"staging"` (valeur du `terraform.tfvars`) et non `"dev"` (valeur par défaut).

---

## Références

- [Fichiers de définition de variables (.tfvars)](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
- [Variables d'entrée — Terraform docs](https://developer.hashicorp.com/terraform/language/values/variables)
