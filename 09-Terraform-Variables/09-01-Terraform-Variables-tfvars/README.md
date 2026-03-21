# Variables Terraform

## Surcharge des valeurs `default` avec le fichier `terraform.tfvars`

## Utilisation de `terraform.tfvars` pour Surcharger les Valeurs des Variables

Dans Terraform, vous pouvez personnaliser vos configurations Terraform sans modifier le code en utilisant un fichier **`terraform.tfvars`**.

- Le fichier `terraform.tfvars` vous permet de définir des valeurs personnalisées pour vos variables Terraform.
- Lorsque vous exécutez des commandes Terraform, il **lit automatiquement** `terraform.tfvars` et **chargera automatiquement** les variables présentes dans ce fichier en remplaçant les valeurs par défaut dans `variables.tf`
- Le nom du fichier doit être exactement ***`terraform.tfvars`***
- Vous pouvez également utiliser ***`terraform.tfvars.json`*** — les fichiers dont les noms se terminent par *.json* sont analysés comme des objets JSON, les propriétés de l'objet racine correspondant aux noms des variables

- **Syntaxe**

    ```hcl
    nom_variable = "nouvelle_valeur"
    ```

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
    ```

- Dans l'exemple ci-dessus, nous avons défini cinq variables :
    1. `aws_region` : région AWS par défaut à utiliser
    2. `owner` : Nom de l'ingénieur qui crée les resources
    3. `ec2_ami` : AMI EC2 AWS
    4. `ec2_instance_type` : Type d'instance EC2 AWS
    5. `instance_count` : Nombre d'instances EC2 à créer

- Maintenant, créons le fichier `terraform.tfvars` et voyons comment il surcharge les variables par défaut.
- Surchargeons les variables `ec2_instance_type` et `owner` dans notre configuration. Créez un fichier `terraform.tfvars` comme ceci :

    [terraform.tfvars](./terraform.tfvars)
    ```hcl
    ec2_instance_type = "t3.small"
    owner             = "Amar"
    ```

- Sortie de ***`terraform plan`***

    - Vous pouvez constater le changement d'`ec2_instance_type` à *t3.small* et d'`owner` à *Amar*

    ```hcl
    $ terraform plan

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # aws_instance.myec2[0] will be created
    + resource "aws_instance" "myec2" {
        + ami                                  = "ami-0df435f331839b2d6"
        ...
        + instance_type                        = "t3.small"
        ...
        + tags_all                             = {
            + "Name"      = "Linux2023"
            + "Owner"     = "Amar"
            + "Terraform" = "yes"
            }
        ...
        }

    Plan: 1 to add, 0 to change, 0 to destroy.
    ```

## Références :

[Fichiers de Définition de Variables (.tfvars)](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

