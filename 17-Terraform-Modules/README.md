> ⚙️ Ce lab utilise **LocalStack** — aucune credential AWS réelle requise.

# Modules Terraform

> This module now composes three local modules: `vpc`, `ec2`, and `s3`. The VPC module creates the network, the EC2 module consumes the VPC subnet output, and the S3 module creates a versioned bucket for the same environment.

## Modules Terraform

- Les modules Terraform sont des **unités de configuration d'infrastructure autonomes et réutilisables**.
- Les modules Terraform encapsulent une **collection de fichiers de configuration Terraform (généralement des fichiers `.tf`) au sein d'un seul répertoire**.
- Ils agissent comme des **blocs de construction réutilisables** pour votre infrastructure.

**Avantages des modules :**

- **Réutilisabilité du code :** Définissez les composants d'infrastructure une seule fois et réutilisez-les dans vos configurations ou à travers différents projets.
- **Meilleure organisation :** Décomposez les configurations complexes en modules plus petits et gérables pour une meilleure lisibilité et maintenabilité.
- **Collaboration :** Partagez des modules avec vos collègues ou au sein d'une équipe, favorisant la cohérence et réduisant la duplication des efforts.

## Structure d'un Module

Un répertoire de module Terraform typique contient :

- `main.tf`      : Le fichier de configuration principal définissant les resources du module à l'aide de providers.
- `variables.tf` : Définit les variables qui peuvent être personnalisées lors de l'utilisation du module.
- `outputs.tf`   : Définit les valeurs que le module peut exposer à la configuration appelante.
- `README.md`    : Fichier optionnel de documentation

```
mon-projet/
├── main.tf               # Configuration principale qui appelle le module
├── variables.tf
├── outputs.tf
└── modules/
    └── vpc/              # Module VPC réutilisable
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Utilisation des Modules

- Les modules sont appelés (ou instanciés) dans d'autres configurations Terraform à l'aide du bloc **`module`**.
- Vous pouvez **fournir des valeurs pour les variables du module lors de l'instanciation**, personnalisant ainsi son comportement.
- Les outputs d'un module peuvent être référencés dans la configuration appelante pour utiliser les résultats du module.
- **Modules Locaux vs. Distants :** Les modules peuvent résider dans le système de fichiers local (modules locaux) ou être récupérés depuis des sources externes comme le Terraform Registry (modules distants).

**Syntaxe** :

```hcl
module "nom_local" {
  source = "./chemin/vers/module"  # module local
  # ou
  source  = "hashicorp/consul/aws" # module distant depuis le Terraform Registry
  version = "~> 0.1"

  # Variables du module
  variable1 = "valeur1"
  variable2 = "valeur2"
}
```

## Exemple : Module VPC

Créons un module VPC réutilisable et appelons-le depuis notre configuration principale.

### Fichiers du Module (`modules/vpc/`)

[modules/vpc/main.tf](./modules/vpc/main.tf)

```hcl
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.vpc_name}-subnet"
  }
}
```

[modules/vpc/variables.tf](./modules/vpc/variables.tf)

```hcl
variable "vpc_cidr" {
  description = "CIDR du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Nom du VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR du Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zone de disponibilité AWS"
  type        = string
  default     = "us-east-1a"
}
```

[modules/vpc/outputs.tf](./modules/vpc/outputs.tf)

```hcl
output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID du Subnet créé"
  value       = aws_subnet.this.id
}
```

### Fichiers de la Configuration Principale

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------
# Provider AWS — LocalStack (simulation locale, aucune credential AWS réelle)
# LocalStack doit être lancé : docker run -d -p 4566:4566 localstack/localstack
# ---------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region

  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }

  default_tags {
    tags = {
      Terraform = "yes"
      Owner     = var.owner
    }
  }
}
```

[01_variables.tf](./01_variables.tf)

```hcl
variable "aws_region" {
  description = "Région AWS dans laquelle les resources seront créées"
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Nom de l'ingénieur qui crée les resources"
  type        = string
  default     = "Venkatesh"
}
```

[02_main.tf](./02_main.tf)

```hcl
# VPC module for the dev environment
module "vpc_dev" {
  source = "./modules/vpc"

  vpc_name          = "MyVPC-Dev"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# EC2 module composed with the dev VPC subnet
module "ec2_dev" {
  source = "./modules/ec2"

  ami_id        = "ami-1234567890abcdef0"
  instance_type = "t2.micro"
  subnet_id     = module.vpc_dev.subnet_id

  tags = {
    Name        = "MyEC2-Dev"
    Environment = "dev"
  }
}

# S3 module composed with the same environment
module "s3_dev" {
  source = "./modules/s3"

  bucket_name        = "terraform-modules-dev-demo-bucket"
  versioning_enabled = true

  tags = {
    Environment = "dev"
  }
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
output "vpc_dev_id" {
  description = "ID du VPC Dev"
  value       = module.vpc_dev.vpc_id
}

output "ec2_dev_instance_id" {
  description = "ID of the dev EC2 instance."
  value       = module.ec2_dev.instance_id
}

output "s3_dev_bucket_id" {
  description = "ID of the dev S3 bucket."
  value       = module.s3_dev.bucket_id
}
```

- Dans l'exemple ci-dessus,

  1. The **VPC module** creates the network foundation and exposes `subnet_id`.
  2. The **EC2 module** consumes `module.vpc_dev.subnet_id` to launch an instance in that subnet.
  3. The **S3 module** creates a versioned bucket for the same environment.
  4. Module outputs are accessed from the root configuration with `module.<module_name>.<output_name>`.

---

## Exécution Pas à Pas

### Étape 1 — Démarrer LocalStack

```shell
docker run -d -p 4566:4566 localstack/localstack
```

Vérifiez que LocalStack répond :

```shell
curl http://localhost:4566/_localstack/health
```

### Étape 2 — Exécuter les Commandes Terraform

1. ***`terraform init`*** : *Initialiser* Terraform (télécharge également les modules locaux)
2. ***`terraform validate`*** : *Valider* le code Terraform
3. ***`terraform fmt`*** : *Formater* le code Terraform
4. ***`terraform plan`*** : *Réviser* le plan Terraform
5. ***`terraform apply`*** : *Créer* des Resources avec Terraform

<details>
<summary> <i>terraform apply</i> </summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

# module.vpc_dev.aws_vpc.this will be created
# module.vpc_dev.aws_subnet.this will be created
# module.ec2_dev.aws_instance.this will be created
# module.ec2_dev.aws_eip.this will be created
# module.s3_dev.aws_s3_bucket.this will be created
# module.s3_dev.aws_s3_bucket_versioning.this will be created

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ec2_dev_instance_id = (known after apply)
  + ec2_dev_public_ip   = (known after apply)
  + s3_dev_bucket_arn   = (known after apply)
  + s3_dev_bucket_id    = (known after apply)
  + vpc_dev_id          = (known after apply)

module.vpc_dev.aws_vpc.this: Creating...
module.vpc_dev.aws_vpc.this: Creation complete after 1s [id=vpc-0a1b2c3d4e5f00010]
module.vpc_dev.aws_subnet.this: Creating...
module.vpc_dev.aws_subnet.this: Creation complete after 1s [id=subnet-0a1b2c3d4e5f00010]
module.ec2_dev.aws_instance.this: Creating...
module.ec2_dev.aws_instance.this: Creation complete after 1s [id=i-0a1b2c3d4e5f00010]
module.ec2_dev.aws_eip.this: Creating...
module.ec2_dev.aws_eip.this: Creation complete after 1s [id=eipalloc-0a1b2c3d4e5f00010]
module.s3_dev.aws_s3_bucket.this: Creating...
module.s3_dev.aws_s3_bucket.this: Creation complete after 1s [id=terraform-modules-dev-demo-bucket]
module.s3_dev.aws_s3_bucket_versioning.this: Creating...
module.s3_dev.aws_s3_bucket_versioning.this: Creation complete after 1s [id=terraform-modules-dev-demo-bucket]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

ec2_dev_instance_id = "i-0a1b2c3d4e5f00010"
ec2_dev_public_ip = "203.0.113.10"
s3_dev_bucket_id = "terraform-modules-dev-demo-bucket"
vpc_dev_id = "vpc-0a1b2c3d4e5f00010"
```

</details>

**Avantages de l'Utilisation des Modules :**

- **Réduction de la duplication de code :** Écrivez le code une seule fois et réutilisez-le dans toute votre infrastructure.
- **Meilleure maintenabilité :** Plus facile de mettre à jour et gérer les composants d'infrastructure en un seul endroit.
- **Conception modulaire :** Favorise une approche plus modulaire et évolutive de la configuration d'infrastructure.

## Références :

Modules Terraform : https://developer.hashicorp.com/terraform/language/modules

Terraform Registry : https://registry.terraform.io/

LocalStack — Documentation officielle : https://docs.localstack.cloud/
