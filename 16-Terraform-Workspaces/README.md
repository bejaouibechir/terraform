> ⚙️ Ce lab utilise **LocalStack** — aucune credential AWS réelle requise.

# Workspaces Terraform

- Les workspaces Terraform vous permettent de **gérer différents ensembles de resources d'infrastructure** en utilisant la **même configuration Terraform** en isolant les fichiers state.
- **Chaque workspace peut avoir son propre state**, vous permettant de travailler sur différents environnements (comme développement, staging et production) sans affecter les autres.
- Terraform démarre avec un workspace *par défaut* nommé "***default***" que vous ne pouvez pas supprimer.
- Les workspaces **ne remplacent pas les configurations Terraform séparées** si vous avez besoin de credentials ou de contrôles d'accès différents pour chaque environnement.
- Remarque : Les workspaces Terraform CLI sont différents des workspaces dans Terraform Cloud.

## Commandes Workspace

Les commandes suivantes vous aident à gérer et à basculer facilement entre différents environnements ou configurations.

- *`terraform workspace --help`* : affiche le message d'aide pour les commandes workspace
- *`terraform workspace new <nom>`* : Crée un nouveau workspace.
- *`terraform workspace select <nom>`* : Bascule vers un workspace existant.
- *`terraform workspace list`* : Liste tous les workspaces disponibles.
- *`terraform workspace show`* : Affiche le workspace courant.
- *`terraform workspace delete <nom>`* : Supprime un workspace.

## Variable *`terraform.workspace`*

- Dans vos fichiers `.tf`, vous pouvez utiliser la variable **`terraform.workspace`** pour récupérer le **nom du workspace actif** et l'utiliser dynamiquement dans vos configurations.
- Cela permet d'adapter automatiquement le **nom des resources**, le **CIDR**, les **tags** ou tout autre paramètre selon l'environnement.

```hcl
# Exemple : nommer une resource selon le workspace actif
resource "aws_vpc" "myvpc" {
  cidr_block = lookup(var.vpc_cidr, terraform.workspace, "10.0.0.0/16")
  tags = {
    Name = "MyVPC-${terraform.workspace}"
  }
}
```

## Exemple Pratique

Utilisons les workspaces pour déployer le **même VPC** dans trois environnements distincts (**dev**, **staging**, **prod**) avec des CIDRs et des noms différents — le tout avec **une seule configuration Terraform**.

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
      Terraform   = "yes"
      Owner       = var.owner
      Environment = terraform.workspace
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

# CIDR différent par environnement (workspace)
variable "vpc_cidr" {
  description = "CIDR du VPC par environnement"
  type        = map(string)
  default = {
    default = "10.0.0.0/16"
    dev     = "10.1.0.0/16"
    staging = "10.2.0.0/16"
    prod    = "10.3.0.0/16"
  }
}
```

[02_vpc.tf](./02_vpc.tf)

```hcl
resource "aws_vpc" "myvpc" {
  # Le CIDR est sélectionné dynamiquement selon le workspace actif
  cidr_block = lookup(var.vpc_cidr, terraform.workspace, "10.0.0.0/16")

  tags = {
    Name = "MyVPC-${terraform.workspace}"
  }
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.myvpc.id
}

output "vpc_cidr" {
  description = "CIDR du VPC créé"
  value       = aws_vpc.myvpc.cidr_block
}

output "workspace_actif" {
  description = "Nom du workspace Terraform actif"
  value       = terraform.workspace
}
```

- Dans l'exemple ci-dessus :
  - La fonction `lookup()` sélectionne le **CIDR approprié** depuis la map `vpc_cidr` selon le workspace actif
  - Le tag `Name` est dynamiquement défini à `MyVPC-dev`, `MyVPC-staging` ou `MyVPC-prod`
  - Le tag `Environment` dans le provider reprend automatiquement le nom du workspace via `terraform.workspace`

---

## Exécution Pas à Pas

### Étape 1 — Démarrer LocalStack

LocalStack doit être actif avant toute commande Terraform.

```shell
docker run -d -p 4566:4566 localstack/localstack
```

Vérifiez que LocalStack répond :

```shell
curl http://localhost:4566/_localstack/health
```

### Étape 2 — Initialiser Terraform

```shell
terraform init
```

### Étape 3 — Vérifier le workspace actif (default par défaut)

```shell
terraform workspace show
```

```shell
default
```

### Étape 4 — Créer et basculer vers le workspace *dev*

```shell
terraform workspace new dev
```

<details>
<summary> <i>terraform workspace new dev</i> </summary>

```shell
$ terraform workspace new dev
Created and switched to workspace "dev"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

</details>

### Étape 5 — Appliquer la configuration dans le workspace *dev*

```shell
terraform apply -auto-approve
```

<details>
<summary> <i>terraform apply (workspace dev)</i> </summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.myvpc will be created
  + resource "aws_vpc" "myvpc" {
      + cidr_block = "10.1.0.0/16"
      + id         = (known after apply)
      + tags       = {
          + "Environment" = "dev"
          + "Name"        = "MyVPC-dev"
          + "Owner"       = "Venkatesh"
          + "Terraform"   = "yes"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

aws_vpc.myvpc: Creating...
aws_vpc.myvpc: Creation complete after 1s [id=vpc-0a1b2c3d4e5f00011]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

vpc_cidr        = "10.1.0.0/16"
vpc_id          = "vpc-0a1b2c3d4e5f00011"
workspace_actif = "dev"
```

</details>

### Étape 6 — Créer et basculer vers le workspace *staging*, puis appliquer

```shell
terraform workspace new staging
terraform apply -auto-approve
```

<details>
<summary> <i>terraform apply (workspace staging)</i> </summary>

```shell
$ terraform workspace new staging
Created and switched to workspace "staging"!

$ terraform apply -auto-approve

aws_vpc.myvpc: Creating...
aws_vpc.myvpc: Creation complete after 1s [id=vpc-0a1b2c3d4e5f00022]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

vpc_cidr        = "10.2.0.0/16"
vpc_id          = "vpc-0a1b2c3d4e5f00022"
workspace_actif = "staging"
```

</details>

### Étape 7 — Créer et basculer vers le workspace *prod*, puis appliquer

```shell
terraform workspace new prod
terraform apply -auto-approve
```

<details>
<summary> <i>terraform apply (workspace prod)</i> </summary>

```shell
$ terraform workspace new prod
Created and switched to workspace "prod"!

$ terraform apply -auto-approve

aws_vpc.myvpc: Creating...
aws_vpc.myvpc: Creation complete after 1s [id=vpc-0a1b2c3d4e5f00033]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

vpc_cidr        = "10.3.0.0/16"
vpc_id          = "vpc-0a1b2c3d4e5f00033"
workspace_actif = "prod"
```

</details>

### Étape 8 — Lister tous les workspaces

```shell
terraform workspace list
```

```shell
  default
  dev
  staging
* prod
```

> Le symbole `*` indique le **workspace actuellement actif**.

### Étape 9 — Basculer vers un workspace existant

```shell
terraform workspace select dev
```

```shell
Switched to workspace "dev".
```

### Étape 10 — Observer l'isolation des fichiers state

Après ces opérations, Terraform crée un répertoire `terraform.tfstate.d/` contenant un fichier state **isolé par workspace** :

```
terraform.tfstate.d/
├── dev/
│   └── terraform.tfstate
├── staging/
│   └── terraform.tfstate
└── prod/
    └── terraform.tfstate
```

- Chaque workspace possède son **propre fichier state indépendant**
- Les modifications dans un workspace **n'affectent pas** les autres
- Le workspace `default` utilise le fichier `terraform.tfstate` à la racine du projet

### Étape 11 — Nettoyage (*`terraform destroy`*)

> **Uniquement pour les tests** — les resources sont locales à LocalStack et disparaissent à l'arrêt du conteneur

```shell
# Détruire dans chaque workspace
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select staging
terraform destroy -auto-approve

terraform workspace select prod
terraform destroy -auto-approve

# Revenir au workspace default et supprimer les workspaces
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```

## Références :

https://developer.hashicorp.com/terraform/language/state/workspaces

https://developer.hashicorp.com/terraform/cli/workspaces

https://docs.localstack.cloud/
