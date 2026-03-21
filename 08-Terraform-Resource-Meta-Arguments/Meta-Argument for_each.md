# Meta-Argument `for_each`

## Description

Le meta-argument `for_each` permet de **créer une instance par élément** d'une `map` ou d'un `set of strings`.
Chaque instance est identifiée par une **clé nommée** : `["dev"]`, `["prod"]`...

- Utiliser `each.key` pour la clé et `each.value` pour la valeur
- Référence : `aws_s3_bucket.env_bucket["dev"].id`
- **Préféré à `count`** quand les instances ont une identité distincte : supprimer "dev" ne recrée pas "prod"

![for_each - concept](C:\Users\DELL\Desktop\terraform-beginners-guide\08-Terraform-Resource-Meta-Arguments\imgs\for_each-concept.jpg)

---

## Exemple — `00_provider.tf`

```hcl
terraform {
  required_version = "~> 1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

## Exemple — `main.tf`

```hcl
locals {
  buckets = {
    "dev"     = "my-dev-bucket"
    "staging" = "my-staging-bucket"
    "prod"    = "my-prod-bucket"
  }
}

resource "aws_s3_bucket" "env_bucket" {
  for_each = local.buckets

  bucket = each.value

  tags = {
    Name        = each.value
    Environment = each.key
  }
}
```

---

## Démonstration — commandes Terraform

### 1. `terraform init` — Initialiser

```bash
terraform init
```

### 2. `terraform validate` — Valider

```bash
terraform validate
```

### 3. `terraform fmt` — Formater

```bash
terraform fmt
```

### 4. `terraform plan` — Réviser

```bash
terraform plan
```

```
Plan: 3 to add, 0 to change, 0 to destroy.
  + aws_s3_bucket.env_bucket["dev"]
  + aws_s3_bucket.env_bucket["staging"]
  + aws_s3_bucket.env_bucket["prod"]
```

### 5. `terraform apply` — Créer les ressources

```bash
terraform apply
```

Confirmer avec **yes**. Terraform crée les **3 buckets S3** identifiés par leur clé.

Vérifier dans la Console AWS → S3 : `my-dev-bucket`, `my-staging-bucket`, `my-prod-bucket` créés.

---

### Nettoyage

### 6. `terraform destroy` — Supprimer les ressources

```bash
terraform destroy
```

Confirmer avec **yes**. Terraform supprime les 3 buckets.

---

## `count` vs `for_each`

|                           | `count`                       | `for_each`                             |
| ------------------------- | ----------------------------- | -------------------------------------- |
| **Identifiant**           | Index numérique `[0]`, `[1]`  | Clé nommée `["dev"]`                   |
| **Suppression partielle** | Recrée tous les suivants      | Supprime uniquement l'élément concerné |
| **Lecture**               | `count.index`                 | `each.key` / `each.value`              |
| **Recommandé**            | Instances identiques sans nom | Instances avec identité distincte      |

---

## Références

- [for_each — Terraform docs](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
