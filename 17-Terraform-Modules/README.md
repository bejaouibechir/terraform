# Modules Terraform

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

provider "aws" {
  region = var.aws_region

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
# Appel du module VPC pour l'environnement dev
module "vpc_dev" {
  source = "./modules/vpc"

  vpc_name          = "MyVPC-Dev"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Appel du module VPC pour l'environnement prod
module "vpc_prod" {
  source = "./modules/vpc"

  vpc_name          = "MyVPC-Prod"
  vpc_cidr          = "10.1.0.0/16"
  subnet_cidr       = "10.1.1.0/24"
  availability_zone = "us-east-1b"
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
output "vpc_dev_id" {
  description = "ID du VPC Dev"
  value       = module.vpc_dev.vpc_id
}

output "vpc_prod_id" {
  description = "ID du VPC Prod"
  value       = module.vpc_prod.vpc_id
}
```

- Dans l'exemple ci-dessus,
  
  1. Le **module VPC** est défini une seule fois dans `modules/vpc/`
  2. Il est **réutilisé deux fois** : une fois pour l'environnement dev et une fois pour l'environnement prod
  3. Chaque appel de module fournit ses propres valeurs de variables (`vpc_name`, `vpc_cidr`, etc.)
  4. Les **outputs du module** (`vpc_id`, `subnet_id`) sont accessibles depuis la configuration principale via `module.<nom_module>.<nom_output>`

- Exécutons les commandes Terraform pour comprendre le comportement des modules
  
  1. ***`terraform init`*** : *Initialiser* Terraform (télécharge également les modules distants)
  2. ***`terraform validate`*** : *Valider* le code Terraform
  3. ***`terraform fmt`*** : *Formater* le code Terraform
  4. ***`terraform plan`*** : *Réviser* le plan Terraform
  5. ***`terraform apply`*** : *Créer* des Resources avec Terraform
  
  <details>
  <summary> <i>terraform apply</i> </summary>
  
  ```hcl
  $ terraform apply
  
  Terraform used the selected providers to generate the following execution plan.
  Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
  # module.vpc_dev.aws_vpc.this will be created
  + resource "aws_vpc" "this" {
      + cidr_block       = "10.0.0.0/16"
      + id               = (known after apply)
      + tags             = {
          + "Name" = "MyVPC-Dev"
        }
    }
  
  # module.vpc_dev.aws_subnet.this will be created
  + resource "aws_subnet" "this" {
      + availability_zone = "us-east-1a"
      + cidr_block        = "10.0.1.0/24"
      + id                = (known after apply)
      + vpc_id            = (known after apply)
    }
  
  # module.vpc_prod.aws_vpc.this will be created
  + resource "aws_vpc" "this" {
      + cidr_block       = "10.1.0.0/16"
      + id               = (known after apply)
      + tags             = {
          + "Name" = "MyVPC-Prod"
        }
    }
  
  # module.vpc_prod.aws_subnet.this will be created
  + resource "aws_subnet" "this" {
      + availability_zone = "us-east-1b"
      + cidr_block        = "10.1.1.0/24"
      + id                = (known after apply)
      + vpc_id            = (known after apply)
    }
  
  Plan: 4 to add, 0 to change, 0 to destroy.
  
  Changes to Outputs:
    + vpc_dev_id  = (known after apply)
    + vpc_prod_id = (known after apply)
  
  Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
  
  Outputs:
  
  vpc_dev_id  = "vpc-0ab12cd34ef567890"
  vpc_prod_id = "vpc-0cd34ef56ab789012"
  ```
  
  </details>

**Avantages de l'Utilisation des Modules :**

- **Réduction de la duplication de code :** Écrivez le code une seule fois et réutilisez-le dans toute votre infrastructure.
- **Meilleure maintenabilité :** Plus facile de mettre à jour et gérer les composants d'infrastructure en un seul endroit.
- **Conception modulaire :** Favorise une approche plus modulaire et évolutive de la configuration d'infrastructure.

## Références :

Modules Terraform : https://developer.hashicorp.com/terraform/language/modules

Terraform Registry : https://registry.terraform.io/
