# Meta-Argument `provider`

## Description

Le meta-argument `provider` permet d'**assigner une ressource à un provider spécifique** lorsqu'il existe plusieurs instances du même provider (multi-région, multi-compte).

- Par défaut, Terraform utilise le provider sans alias
- Avec `alias`, on peut déclarer plusieurs instances du même provider
- Cas d'usage : déployer des ressources dans **plusieurs régions AWS** ou chez **plusieurs fournisseurs cloud** dans la même configuration

![provider - concept](C:\Users\DELL\Desktop\terraform-beginners-guide\08-Terraform-Resource-Meta-Arguments\imgs\provider-concept.jpg)

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

# Provider par défaut — us-east-1
provider "aws" {
  region = "us-east-1"
}

# Provider avec alias — eu-west-1
provider "aws" {
  alias  = "eu"
  region = "eu-west-1"
}
```

## Exemple — `main.tf`

```hcl
# Bucket créé en us-east-1 (provider par défaut)
resource "aws_s3_bucket" "us_bucket" {
  bucket = "my-bucket-us-east"
  tags   = { Region = "us-east-1" }
}

# Bucket créé en eu-west-1 (provider avec alias)
resource "aws_s3_bucket" "eu_bucket" {
  provider = aws.eu
  bucket   = "my-bucket-eu-west"
  tags     = { Region = "eu-west-1" }
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
  + aws_s3_bucket.us_bucket   (provider: aws → us-east-1)
  + aws_s3_bucket.eu_bucket   (provider: aws.eu → eu-west-1)
```

### 5. `terraform apply` — Créer les ressources

```bash
terraform apply
```

Confirmer avec **yes**. Terraform crée les 2 buckets dans leurs régions respectives.

Vérifier dans la Console AWS → S3 : changer la région en haut à droite pour voir chaque bucket dans sa région.

---

### Nettoyage

### 6. `terraform destroy` — Supprimer les ressources

```bash
terraform destroy
```

Confirmer avec **yes**. Terraform supprime les 2 buckets.

---

## Références

- [provider meta-argument — Terraform docs](https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider)
- [Provider aliases — Terraform docs](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
