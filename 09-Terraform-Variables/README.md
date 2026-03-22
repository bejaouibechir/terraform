# Variables Terraform

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

Les variables Terraform permettent de **paramétrer vos configurations** pour les rendre flexibles, réutilisables et adaptables à différents environnements.

---

## Concepts fondamentaux

- Les variables sont des conteneurs pour **stocker et gérer des valeurs** : texte, nombres ou structures complexes.
- Elles permettent de **paramétrer vos configurations** : noms d'environnements, compteurs, listes de serveurs...
- Elles sont déclarées avec le bloc `variable` en spécifiant le **nom**, le **type** et une **valeur par défaut** optionnelle.
- Elles rendent votre code réutilisable dans différents contextes : `dev`, `staging`, `prod`.

---

## Fichiers du lab racine

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
  count    = var.instance_count
  filename = "${path.module}/output/server-${count.index}.conf"
  content  = "SERVER=${random_pet.server.id}-${count.index}\nENV=${var.environment}\nOWNER=${var.owner}"
}

output "server_name" {
  value = random_pet.server.id
}

output "config_files" {
  value = local_file.config[*].filename
}
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
  description = "Nombre de fichiers/instances à créer"
  type        = number
  default     = 1
}
```

Trois variables sont définies :

1. `environment` — nom de l'environnement cible (`dev`, `staging`, `prod`)
2. `owner` — nom de l'ingénieur responsable
3. `instance_count` — nombre de fichiers de configuration à générer

---

## Types de variables

| Type            | Exemple de valeur                        | Usage typique                     |
| --------------- | ---------------------------------------- | --------------------------------- |
| `string`        | `"dev"`                                  | Noms, identifiants, régions       |
| `number`        | `3`                                      | Compteurs, ports, tailles         |
| `bool`          | `true`                                   | Flags d'activation                |
| `list(string)`  | `["web-01", "api-01"]`                   | Listes de noms ou d'identifiants  |
| `map(string)`   | `{ env = "prod" }`                       | Paires clé/valeur                 |
| `object({...})` | `{ port = 8080, env = "dev" }`           | Structures complexes typées       |

---

## Ordre de priorité des variables

Terraform charge les variables dans l'ordre suivant — **la source du bas peut être écrasée par toutes celles du dessus** :

| Priorité                | Source                                                           | Exemple                                    |
| ----------------------- | ---------------------------------------------------------------- | ------------------------------------------ |
| **5** *(la plus haute)* | Options `-var` et `-var-file` en ligne de commande               | `terraform plan -var="environment=prod"`   |
| **4**                   | Fichiers `*.auto.tfvars` / `*.auto.tfvars.json` (ordre lexical)  | `prod.auto.tfvars`                         |
| **3**                   | Fichier `terraform.tfvars.json`                                  | `{ "environment": "prod" }`                |
| **2**                   | Fichier `terraform.tfvars`                                       | `environment = "prod"`                     |
| **1** *(la plus faible)*| Variables d'environnement `TF_VAR_`                              | `export TF_VAR_environment=prod`           |

> La même variable ne peut pas recevoir plusieurs valeurs au sein d'une **seule et même source**. En cas de conflit entre sources, Terraform utilise la valeur de la source ayant la **priorité la plus haute**.

---

## Surcharge via `-var` en ligne de commande

```bash
terraform plan -var="environment=staging" -var="owner=Alice"
```

Sauvegarder et réutiliser un plan :

```bash
terraform plan -var="environment=prod" -out=tfplan.plan
terraform apply tfplan.plan
```

> Avec un fichier plan, `terraform apply` **n'affiche pas de prompt** `yes/no` et applique exactement ce qui a été planifié.

---

## Surcharge via variables d'environnement `TF_VAR_`

```bash
export TF_VAR_environment=staging
export TF_VAR_owner=Bob

terraform plan
# → environment = "staging"  ← TF_VAR_ écrase default

unset TF_VAR_environment
unset TF_VAR_owner
```

> Attention : les variables d'environnement ont une priorité **inférieure** à `terraform.tfvars` et `*.auto.tfvars`.

---

## Sous-modules disponibles

| Module | Thème |
| ------ | ----- |
| [09-01](./09-01-Terraform-Variables-tfvars/) | Fichier `terraform.tfvars` — surcharge des valeurs par défaut |
| [09-02](./09-02-Terraform-Variables-tfvars-var-file/) | Fichiers `.tfvars` multiples avec `-var-file` |
| [09-03](./09-03-Terraform-Variables-list/) | Variables de type `list(string)` |
| [09-04](./09-04-Terraform-Variables-map/) | Variables de type `map(object)` |
| [09-05](./09-05-Custom-Validation-Rules/) | Règles de validation personnalisées (`validation {}`) |
| [09-06](./09-06-Sensitive-Variables/) | Variables sensibles (`sensitive = true`) |

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

---

## Références

- [Variables d'entrée — Terraform docs](https://developer.hashicorp.com/terraform/language/values/variables)
- [Variable d'environnement TF_VAR_name](https://developer.hashicorp.com/terraform/cli/config/environment-variables#tf_var_name)
- [Priorité de définition des variables](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)
