# Meta-Argument `lifecycle`

## Description

Le meta-argument `lifecycle` permet de **contrôler des aspects spécifiques du cycle de vie** d'une ressource : sa création, sa destruction et la gestion des changements.

Il contient **4 options** :

| Option                  | Rôle                                                            |
| ----------------------- | --------------------------------------------------------------- |
| `create_before_destroy` | Crée le remplacement avant de détruire l'ancien (zéro downtime) |
| `prevent_destroy`       | Bloque toute destruction de la ressource                        |
| `ignore_changes`        | Ignore les changements sur certains attributs lors du plan      |
| `replace_triggered_by`  | Force la recréation si une autre ressource change               |

![lifecycle - concept](C:\Users\DELL\Desktop\terraform-beginners-guide\08-Terraform-Resource-Meta-Arguments\imgs\lifecycle-concept.jpg)

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
resource "aws_s3_bucket" "critical" {
  bucket = "my-critical-bucket"

  tags = {
    Name        = "critical-bucket"
    Environment = "prod"
    ManagedBy   = "terraform"
  }

  lifecycle {
    # 1 — Crée le nouveau bucket avant de détruire l'ancien
    create_before_destroy = true

    # 2 — Empêche la destruction accidentelle
    prevent_destroy = true

    # 3 — Ignore les changements de tags (gérés manuellement)
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket" "app" {
  bucket = "my-app-bucket"

  lifecycle {
    # 4 — Recrée ce bucket si le bucket "critical" est recréé
    replace_triggered_by = [aws_s3_bucket.critical]
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
Plan: 2 to add, 0 to change, 0 to destroy.
  + aws_s3_bucket.critical
  + aws_s3_bucket.app
```

### 5. `terraform apply` — Créer les ressources

```bash
terraform apply
```

Confirmer avec **yes**. Terraform crée les 2 buckets.

Vérifier dans la Console AWS → S3 : `my-critical-bucket` et `my-app-bucket` sont créés.

**Test `prevent_destroy`** : modifier le code pour tenter de détruire `critical` → Terraform affiche une erreur :

```
Error: Instance cannot be destroyed
  on main.tf: prevent_destroy is set to true
```

---

### Nettoyage

### 6. `terraform destroy` — Supprimer les ressources

```bash
terraform destroy
```

> **Important** : retirer `prevent_destroy = true` avant d'exécuter `terraform destroy`, sinon Terraform bloque la destruction.

Confirmer avec **yes**. Terraform supprime les 2 buckets.

---

## Références

- [lifecycle — Terraform docs](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
