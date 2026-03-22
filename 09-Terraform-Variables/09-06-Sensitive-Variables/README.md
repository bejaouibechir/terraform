# Variables Terraform — Variables sensibles (`sensitive = true`)

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Variables d'entrée sensibles

Pour gérer les variables d'entrée sensibles dans Terraform, utilisez l'argument **`sensitive = true`** dans le bloc `variable`.

- En définissant `sensitive = true`, vous indiquez que la valeur de cette variable est sensible, et Terraform la traitera en conséquence.
- **Terraform n'affichera pas les valeurs réelles** des variables sensibles dans la console ou les logs lors des opérations `plan` ou `apply`. Il affichera à la place `(sensitive value)`.
- Si une variable sensible est utilisée dans un bloc `output`, **la sortie sera également traitée comme sensible**, et sa valeur ne sera pas affichée sans l'option `--show-sensitive`.
- **Remarque importante :** Bien que Terraform aide à la visibilité et à la protection des données sensibles, vous devez toujours suivre les meilleures pratiques pour la gestion des secrets. Le fichier d'état Terraform (`terraform.tfstate`) **stocke les valeurs sensibles en texte clair** — protégez l'accès à ce fichier.

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

**`01_rds.tf`**

```hcl
# Variables sensibles — démontre sensitive = true
# Les valeurs ne s'affichent pas dans les logs terraform apply/output

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%"
}

resource "local_sensitive_file" "db_config" {
  filename = "${path.module}/output/db.conf"
  content  = <<-EOT
    DB_HOST=localhost
    DB_USER=${var.db_username}
    DB_PASSWORD=${var.db_password != "" ? var.db_password : random_password.db_password.result}
    DB_NAME=myapp
  EOT
}

output "db_password_generated" {
  description = "Mot de passe généré (sensible — masqué dans les logs)"
  value       = random_password.db_password.result
  sensitive   = true
}
```

Deux ressources sont créées :

1. `random_password.db_password` — génère un mot de passe aléatoire de 16 caractères avec des caractères spéciaux parmi `!#$%`.
2. `local_sensitive_file.db_config` — écrit un fichier de configuration de base de données. Si `var.db_password` est vide, le mot de passe généré est utilisé.

**`02_variables.tf`**

```hcl
variable "db_username" {
  description = "Nom d'utilisateur base de données"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "Mot de passe base de données (laisser vide pour générer automatiquement)"
  type        = string
  sensitive   = true
  default     = ""
}
```

Les deux variables sont déclarées avec `sensitive = true` :

- `db_username` — identifiant de connexion (valeur par défaut : `"admin"`).
- `db_password` — mot de passe. Si laissé vide (`""`), `random_password` génère automatiquement un mot de passe sécurisé.

---

## Comportement de `sensitive = true`

### Pendant `terraform plan` et `terraform apply`

Les valeurs sensibles sont remplacées par `(sensitive value)` :

```
  # local_sensitive_file.db_config will be created
  + resource "local_sensitive_file" "db_config" {
      + content              = (sensitive value)
      + filename             = "./output/db.conf"
    }

  # random_password.db_password will be created
  + resource "random_password" "db_password" {
      + id               = (known after apply)
      + length           = 16
      + result           = (sensitive value)
      + special          = true
      + override_special = "!#$%"
    }
```

### Outputs masqués

L'output `db_password_generated` est déclaré `sensitive = true` :

```bash
$ terraform output
db_password_generated = <sensitive>
```

Pour afficher la valeur (uniquement en local, jamais dans les pipelines CI/CD) :

```bash
terraform output -raw db_password_generated
```

### Fichier d'état (`terraform.tfstate`)

Le state file **stocke les valeurs sensibles en texte clair**. Protégez l'accès à ce fichier et utilisez un backend distant sécurisé (ex : Terraform Cloud, S3 avec chiffrement) en production.

---

## `local_sensitive_file` vs `local_file`

| Ressource              | Permissions fichier | Usage recommandé             |
| ---------------------- | ------------------- | ---------------------------- |
| `local_file`           | `0777` (lecture)    | Fichiers non sensibles       |
| `local_sensitive_file` | `0700` (restreint)  | Fichiers contenant des secrets |

`local_sensitive_file` applique automatiquement des permissions restreintes sur le fichier généré.

---

## Commandes Terraform

```bash
terraform init
terraform validate
terraform fmt

# Utiliser les valeurs par défaut (mot de passe généré automatiquement)
terraform plan
terraform apply     # confirmer avec yes

# Passer un mot de passe personnalisé
terraform apply -var="db_password=MonMotDePasse123!"

# Afficher les outputs (valeur masquée)
terraform output

# Afficher la valeur sensible (à utiliser avec précaution)
terraform output -raw db_password_generated

terraform destroy   # confirmer avec yes
```

---

## Bonnes pratiques

- Ne stockez **jamais** de secrets dans les fichiers `.tf` versionnés.
- Utilisez `-var` ou des variables d'environnement `TF_VAR_` pour passer les secrets.
- En production, intégrez un système de gestion des secrets (HashiCorp Vault, gestionnaire de secrets cloud).
- Ajoutez `terraform.tfstate` et `*.tfvars` contenant des secrets à votre `.gitignore`.

---

## Références

- [Variables d'entrée sensibles Terraform](https://www.hashicorp.com/blog/terraform-sensitive-input-variables)
- [Protéger les variables d'entrée sensibles](https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables)
- [Ressource `local_sensitive_file`](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file)
- [Ressource `random_password`](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)
