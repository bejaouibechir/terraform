# Meta-Argument `depends_on`

## Description

Le meta-argument `depends_on` permet de **déclarer une dépendance explicite** entre ressources.
Terraform attend que la ressource dépendante soit entièrement créée avant de démarrer la ressource courante.

- **Dépendance implicite** (automatique) : Terraform la détecte via les références dans le code
- **Dépendance explicite** (`depends_on`) : à utiliser uniquement quand la dépendance n'est **pas visible** dans le code (ex : droits IAM, ressources créées en dehors de Terraform)

![depends_on - concept](C:\Users\DELL\Desktop\terraform-beginners-guide\08-Terraform-Resource-Meta-Arguments\imgs\depends_on-concept.jpg)

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
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "main-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = { Name = "public-subnet" }
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  depends_on = [
    aws_vpc.main,
    aws_subnet.public
  ]

  tags = { Name = "app-server" }
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

L'ordre de création est visible dans le plan :

```
Plan: 3 to add, 0 to change, 0 to destroy.
  + aws_vpc.main         (en premier)
  + aws_subnet.public    (après vpc)
  + aws_instance.app     (après vpc + subnet)
```

### 5. `terraform apply` — Créer les ressources

```bash
terraform apply
```

Confirmer avec **yes**. Terraform crée les ressources dans l'ordre : VPC → Subnet → Instance.

Vérifier dans la Console AWS → EC2 : l'instance `app-server` est en état `running`.

---

### Nettoyage

### 6. `terraform destroy` — Supprimer les ressources

```bash
terraform destroy
```

Confirmer avec **yes**. Terraform détruit les ressources dans l'ordre inverse : Instance → Subnet → VPC.

---

## Références

- [depends_on — Terraform docs](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)
