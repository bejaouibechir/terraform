# Variables Terraform

## Surcharge des valeurs `default` avec différents `.tfvars` via l'option *`-var-file`*

## Utilisation de plusieurs `.tfvars` pour des Configurations Spécifiques à l'Environnement

Dans Terraform, vous pouvez créer plusieurs `.tfvars` pour répondre à vos variables spécifiques à l'environnement
- Vous pouvez gérer des configurations pour différents environnements, comme la pré-production et la production, en utilisant des fichiers `.tfvars` séparés.
- Chaque fichier `.tfvars` contient des surcharges de variables spécifiques à son environnement.
- Voici comment configurer et utiliser plusieurs fichiers `.tfvars` :
    - Créez un fichier `.tfvars` séparé pour chaque environnement, comme `pre.tfvars` et `prd.tfvars`.
    - Dans chaque fichier `.tfvars`, spécifiez les surcharges de variables adaptées à cet environnement.

- Vous pouvez utiliser la commande `terraform plan` ou `terraform apply` de l'une des façons suivantes

    - *terraform plan -var-file ./vars/pre.tfvars*
    - *terraform plan -var-file="./vars/pre.tfvars"*
    - *terraform plan -var-file=./vars/pre.tfvars*

- **Exemple** :

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
    #region = "us-east-1"
    region = var.aws_region

    default_tags {
        tags = {
        Terraform = "yes"
        #Owner = "Venkatesh"
        Owner = var.owner
        }
    }
    }
    ```

    [01_ec2.tf](./01_ec2.tf)
    ```hcl
    resource "aws_instance" "myec2" {
    # arguments terraform sans variables
    # ami = "ami-0df435f331839b2d6"
    # instance_type = "t2.micro"
    # count = 1

    # utilisation de variables pour les arguments
    ami           = var.ec2_ami
    instance_type = var.ec2_instance_type
    count         = var.instance_count

    tags = {
        Name = "Linux2023"
        env  = var.env
    }
    }
    ```

    [02_variables.tf](./02_variables.tf)

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

    variable "ec2_ami" {
    description = "AMI EC2 AWS Amazon Linux 2023"
    type        = string
    default     = "ami-0df435f331839b2d6" # Amazon Linux 2023
    }

    variable "ec2_instance_type" {
    description = "Type d'instance EC2"
    type        = string
    default     = "t2.micro"
    }

    variable "instance_count" {
    description = "Nombre d'instances EC2"
    type        = number
    default     = 1
    }

    variable "env" {
    description = "Type d'environnement"
    type        = string
    default     = "dev"
    }
    ```

    ***`pre.tfvars`*** :
    [pre.tfvars](./vars/pre.tfvars)

    ```hcl
    instance_type = "t3.small"
    env           = "PRE"
    ```

    ***`prd.tfvars`*** :
   [prd.tfvars](./vars/prd.tfvars)
    ```hcl
    instance_type = "t3.large"
    env           = "PRD"
    ```


- Dans l'exemple ci-dessus, nous avons défini six variables :
    1. `aws_region` : région AWS par défaut à utiliser
    2. `owner` : Nom de l'ingénieur qui crée les resources
    3. `ec2_ami` : AMI EC2 AWS
    4. `ec2_instance_type` : Type d'instance EC2 AWS
    5. `instance_count` : Nombre d'instances EC2 à créer
    6. `env` : Type d'environnement (PRE, PRD, DEV, UAT)


- Sortie de ***`terraform plan`*** pour ***`pre.tfvars`*** :
    - Vous pouvez constater le changement d'`ec2_instance_type` à *t3.small* et d'`env` à *PRE* dans les tags, définis dans le fichier [*pre.tfvars*](./vars/pre.tfvars)

        ```hcl
        $ terraform plan -var-file="./vars/pre.tfvars"

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

        # aws_instance.myec2[0] will be created
        + resource "aws_instance" "myec2" {
            + ami                                  = "ami-0df435f331839b2d6"
            ...
            + instance_type                        = "t3.small"
            ...
            + tags                                 = {
                + "Name" = "Linux2023"
                + "env"  = "PRE"
                }
            + tags_all                             = {
                + "Name"      = "Linux2023"
                + "Owner"     = "Venkatesh"
                + "Terraform" = "yes"
                + "env"       = "PRE"
                }
            ...
            }

        Plan: 1 to add, 0 to change, 0 to destroy.
        ```

- Sortie de ***`terraform plan`*** pour ***`prd.tfvars`*** :

    - Vous pouvez constater le changement d'`ec2_instance_type` à *t3.large* et d'`env` à *PRD* dans les tags, définis dans le fichier [*prd.tfvars*](./vars/prd.tfvars)

        ```hcl
        $ terraform plan -var-file ./vars/prd.tfvars

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

        # aws_instance.myec2[0] will be created
        + resource "aws_instance" "myec2" {
            + ami                                  = "ami-0df435f331839b2d6"
            ...
            + instance_type                        = "t3.large"
            ...
            + tags                                 = {
                + "Name" = "Linux2023"
                + "env"  = "PRD"
                }
            + tags_all                             = {
                + "Name"      = "Linux2023"
                + "Owner"     = "Venkatesh"
                + "Terraform" = "yes"
                + "env"       = "PRD"
                }
            ...
            }

        Plan: 1 to add, 0 to change, 0 to destroy.

        ```



## Références :

[Fichiers de Définition de Variables (.tfvars)](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

