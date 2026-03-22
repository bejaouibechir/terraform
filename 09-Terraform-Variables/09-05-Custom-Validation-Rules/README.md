# Variables Terraform — Règles de validation personnalisées

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Règles de validation personnalisées (`validation {}`)

Les règles de validation personnalisées permettent d'**imposer des conditions spécifiques** sur les valeurs des variables avant que Terraform n'accepte la configuration.

- **Validation** : conditions que vous définissez à l'intérieur d'un bloc `variable`. Elles peuvent être simples ou complexes.
- **Validation personnalisée** : Terraform permet de créer vos propres règles en utilisant le bloc `validation {}` dans une déclaration de variable.
- **Cas d'usage** :
  - S'assurer que les paramètres requis respectent un format attendu.
  - Vérifier que les valeurs répondent à des critères numériques ou textuels.
  - S'assurer que certaines conditions sont satisfaites **avant** la création des ressources.
- **Avantages** :
  - Ajoute une couche de contrôle supplémentaire sur votre configuration.
  - Aide à **détecter les erreurs tôt** dans le processus de déploiement.
  - Fournit des messages d'erreur explicites pour faciliter le dépannage.

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
  content  = "SERVER=${random_pet.server.id}\nENV=${var.environment}\nPORT=${var.server_port}"
}

output "server_name" { value = random_pet.server.id }
output "server_port" { value = var.server_port }
```

**`02_variables.tf`**

```hcl
variable "environment" {
  description = "Nom de l'environnement (dev, staging, prod uniquement)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit être : dev, staging ou prod."
  }
}

variable "server_port" {
  description = "Port du serveur (entre 1024 et 65535)"
  type        = number
  default     = 8080

  validation {
    condition     = var.server_port >= 1024 && var.server_port <= 65535
    error_message = "Le port doit être compris entre 1024 et 65535."
  }
}
```

---

## Explication des règles de validation

### Variable `environment`

```hcl
validation {
  condition     = contains(["dev", "staging", "prod"], var.environment)
  error_message = "L'environnement doit être : dev, staging ou prod."
}
```

La fonction `contains()` vérifie que la valeur fournie appartient à la liste autorisée. Toute autre valeur (ex : `"production"`, `"uat"`) déclenchera l'erreur.

### Variable `server_port`

```hcl
validation {
  condition     = var.server_port >= 1024 && var.server_port <= 65535
  error_message = "Le port doit être compris entre 1024 et 65535."
}
```

Les ports inférieurs à `1024` sont réservés au système. La règle garantit que seuls des ports applicatifs valides sont utilisés.

---

## Test de validation — valeur incorrecte

### Exemple : `environment = "production"` (valeur invalide)

```bash
$ terraform plan -var="environment=production"

Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Invalid value for variable
│
│   on 02_variables.tf line 1:
│    1: variable "environment" {
│     ├────────────────
│     │ var.environment is "production"
│
│ L'environnement doit être : dev, staging ou prod.
│
│ This was checked by the validation rule at 02_variables.tf:6,3-13.
╵
```

### Exemple : `server_port = 80` (port réservé)

```bash
$ terraform plan -var="server_port=80"

Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Invalid value for variable
│
│   on 02_variables.tf line 12:
│   12: variable "server_port" {
│     ├────────────────
│     │ var.server_port is 80
│
│ Le port doit être compris entre 1024 et 65535.
│
│ This was checked by the validation rule at 02_variables.tf:17,3-13.
╵
```

---

## Test de validation — valeur correcte

```bash
$ terraform plan -var="environment=staging" -var="server_port=9090"

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

---

## Commandes Terraform

```bash
terraform init
terraform validate
terraform fmt

# Test avec valeurs valides
terraform plan -var="environment=staging" -var="server_port=9090"

# Test avec valeurs invalides (déclenchement des erreurs de validation)
terraform plan -var="environment=production"
terraform plan -var="server_port=80"

terraform apply     # confirmer avec yes
terraform destroy   # confirmer avec yes
```

---

## Références

- [Conditions personnalisées Terraform](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions)
- [Bloc `validation` dans les variables](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)
