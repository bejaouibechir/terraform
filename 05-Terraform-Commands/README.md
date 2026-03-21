# Commandes Terraform

Les commandes Terraform constituent le **cycle de vie principal** pour gérer votre infrastructure. Elles sont exécutées dans le répertoire contenant vos fichiers de configuration `.tf`.

---

## Commandes Principales

| Commande               | Description                                                          |
| ---------------------- | -------------------------------------------------------------------- |
| *`terraform init`*     | Initialise le répertoire de travail Terraform                        |
| *`terraform validate`* | Vérifie la syntaxe et la cohérence de la configuration               |
| *`terraform fmt`*      | Formate automatiquement les fichiers `.tf` selon les conventions HCL |
| *`terraform plan`*     | Génère et affiche le plan d'exécution des changements                |
| *`terraform apply`*    | Applique les changements pour créer/modifier/détruire des resources  |
| *`terraform output`*   | Affiche les valeurs des outputs définis                              |
| *`terraform show`*     | Affiche une représentation lisible du state courant                  |
| *`terraform refresh`*  | Met à jour le fichier state avec l'état réel de l'infrastructure     |
| *`terraform destroy`*  | Détruit toutes les resources gérées par la configuration             |

---

## Exemple Pratique

Créons un VPC simple pour explorer chaque commande Terraform et comprendre leur rôle dans le workflow.

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

[02_vpc.tf](./02_vpc.tf)

```hcl
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
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
```

---

## Exécution Pas à Pas

### 1. *`terraform init`*

- **Initialise** le répertoire de travail Terraform.
- Télécharge les **plugins des providers** requis (ici le provider AWS).
- Initialise le **backend** de state.
- Doit être exécuté **en premier**, avant toute autre commande.

```shell
terraform init
```

<details>
<summary> <i>terraform init</i> </summary>

```shell
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.31.0...
- Installed hashicorp/aws v5.31.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
```

</details>

---

### 2. *`terraform fmt`*

- **Formate automatiquement** les fichiers `.tf` selon les conventions de style HCL.
- Assure une **cohérence du code** au sein d'une équipe.
- Retourne les noms des fichiers modifiés.

```shell
# Formater tous les fichiers .tf du répertoire courant
terraform fmt

# Formater récursivement tous les sous-répertoires
terraform fmt -recursive
```

<details>
<summary> <i>terraform fmt</i> </summary>

```shell
$ terraform fmt
02_vpc.tf
```

</details>

---

### 3. *`terraform validate`*

- **Vérifie la syntaxe** et la cohérence de vos fichiers de configuration Terraform.
- Ne contacte **aucun provider** distant — uniquement une vérification locale.
- Utile pour détecter des erreurs de configuration **avant** d'exécuter `terraform plan`.

```shell
terraform validate
```

<details>
<summary> <i>terraform validate</i> </summary>

```shell
$ terraform validate
Success! The configuration is valid.
```

</details>

---

### 4. *`terraform plan`*

- Génère et affiche un **plan d'exécution** des changements que Terraform apportera à l'infrastructure.
- Permet de **réviser les modifications** avant de les appliquer.
- **N'apporte aucune modification** à l'infrastructure réelle.

```shell
# Afficher le plan
terraform plan

# Sauvegarder le plan dans un fichier pour application ultérieure
terraform plan -out=monplan.tfplan
```

<details>
<summary> <i>terraform plan</i> </summary>

```shell
$ terraform plan

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.myvpc will be created
  + resource "aws_vpc" "myvpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + tags                                 = {
          + "Name" = "MyVPC"
        }
      + tags_all                             = {
          + "Name"      = "MyVPC"
          + "Owner"     = "Venkatesh"
          + "Terraform" = "yes"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vpc_cidr = "10.0.0.0/16"
  + vpc_id   = (known after apply)
```

</details>

---

### 5. *`terraform apply`*

- **Applique les changements** définis dans la configuration Terraform pour créer, modifier ou détruire des resources.
- Par défaut, demande une **confirmation interactive** avant d'exécuter les changements.
- Peut être automatisé avec `-auto-approve` (à utiliser avec précaution).

```shell
# Avec confirmation interactive
terraform apply

# Sans confirmation (CI/CD pipelines)
terraform apply -auto-approve

# Appliquer un fichier de plan sauvegardé
terraform apply monplan.tfplan
```

<details>
<summary> <i>terraform apply</i> </summary>

```shell
$ terraform apply

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.myvpc will be created
  + resource "aws_vpc" "myvpc" {
      + cidr_block       = "10.0.0.0/16"
      + id               = (known after apply)
      + tags             = {
          + "Name" = "MyVPC"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vpc_cidr = "10.0.0.0/16"
  + vpc_id   = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.myvpc: Creating...
aws_vpc.myvpc: Creation complete after 3s [id=vpc-0ab12cd34ef567890]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

vpc_cidr = "10.0.0.0/16"
vpc_id   = "vpc-0ab12cd34ef567890"
```

</details>

---

### 6. *`terraform output`*

- Affiche les **valeurs des outputs** définis dans votre configuration après un `terraform apply`.
- Utile pour récupérer des informations sur l'infrastructure déployée (ex. : IDs, adresses IP).

```shell
# Afficher tous les outputs
terraform output

# Afficher un output spécifique
terraform output vpc_id
```

<details>
<summary> <i>terraform output</i> </summary>

```shell
$ terraform output
vpc_cidr = "10.0.0.0/16"
vpc_id   = "vpc-0ab12cd34ef567890"

$ terraform output vpc_id
"vpc-0ab12cd34ef567890"
```

</details>

---

### 7. *`terraform show`*

- Affiche une **représentation lisible par l'humain** du state Terraform courant.
- Permet d'**inspecter l'état réel des resources** sans ouvrir directement le fichier `terraform.tfstate`.

```shell
terraform show
```

<details>
<summary> <i>terraform show</i> </summary>

```shell
$ terraform show
# aws_vpc.myvpc:
resource "aws_vpc" "myvpc" {
    arn                                  = "arn:aws:ec2:us-east-1:520974589522:vpc/vpc-0ab12cd34ef567890"
    cidr_block                           = "10.0.0.0/16"
    enable_dns_support                   = true
    id                                   = "vpc-0ab12cd34ef567890"
    instance_tenancy                     = "default"
    tags                                 = {
        "Name" = "MyVPC"
    }
    tags_all                             = {
        "Name"      = "MyVPC"
        "Owner"     = "Venkatesh"
        "Terraform" = "yes"
    }
}

Outputs:

vpc_cidr = "10.0.0.0/16"
vpc_id   = "vpc-0ab12cd34ef567890"
```

</details>

---

### 8. *`terraform refresh`*

- **Met à jour le fichier state** Terraform avec l'état réel de l'infrastructure.
- Synchronise le state avec l'infrastructure réelle **sans modifier** celle-ci.
- Utile après des **modifications manuelles** effectuées en dehors de Terraform (ex. : depuis la Console AWS).

```shell
terraform refresh
```

<details>
<summary> <i>terraform refresh</i> </summary>

```shell
$ terraform refresh
aws_vpc.myvpc: Refreshing state... [id=vpc-0ab12cd34ef567890]
```

</details>

---

### 9. *`terraform destroy`*

- **Détruit toutes les resources** gérées par la configuration Terraform courante.
- Par défaut, demande une **confirmation interactive** avant d'exécuter la destruction.
- ***À utiliser avec précaution*** — uniquement pour les tests et le nettoyage.

```shell
# Avec confirmation interactive
terraform destroy

# Sans confirmation
terraform destroy -auto-approve
```

<details>
<summary> <i>terraform destroy</i> </summary>

```shell
$ terraform destroy -auto-approve
aws_vpc.myvpc: Refreshing state... [id=vpc-0ab12cd34ef567890]

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_vpc.myvpc will be destroyed
  - resource "aws_vpc" "myvpc" {
      - arn        = "arn:aws:ec2:us-east-1:520974589522:vpc/vpc-0ab12cd34ef567890"
      - cidr_block = "10.0.0.0/16"
      - id         = "vpc-0ab12cd34ef567890"
      - tags       = {
          - "Name" = "MyVPC"
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.

aws_vpc.myvpc: Destroying... [id=vpc-0ab12cd34ef567890]
aws_vpc.myvpc: Destruction complete after 1s

Destroy complete! Resources: 1 destroyed.
```

</details>

---

## Récapitulatif du Workflow Standard

```shell
# 1. Initialiser le répertoire de travail
terraform init

# 2. Formater le code
terraform fmt

# 3. Valider la configuration
terraform validate

# 4. Réviser le plan
terraform plan

# 5. Appliquer les changements
terraform apply

# 6. Inspecter le state
terraform show

# 7. (Nettoyage) Détruire les resources
terraform destroy
```

## Références :

Commandes Terraform CLI : https://developer.hashicorp.com/terraform/cli/commands
