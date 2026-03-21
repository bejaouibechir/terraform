# Variables Terraform

## Implémenter le type de variable `list`


Dans Terraform, vous pouvez utiliser des constructeurs de types complexes comme list et map pour définir des variables.

- **list (ou tuple)** : une **séquence de valeurs**, comme ["t2.micro", "t2.small"].
- Les éléments d'une list ou d'un tuple sont identifiés par des nombres entiers consécutifs, commençant à zéro. [0], [1]


Considérons la variable `ec2_instance_type` comme exemple et implémentons la fonction List

### Définition Précédente :

```hcl
variable "ec2_instance_type" {
    description = "Type d'instance EC2"
    type        = string
    default     = "t2.micro"
}
```

Pour utiliser une list comme constructeur de type complexe pour *instance_type*, vous pouvez la modifier ainsi :
### Type *list*

```hcl
variable "ec2_instance_type" {
    description = "Types d'instances EC2"
    type        = list(string)
    default     = ["t2.micro", "t2.small", "t2.large"]
}
```

Voici ce qui a changé :

- **Déclaration de Type (type)** : Il est maintenant spécifié comme *`list(string)`*, indiquant que la variable est attendue comme une *`list`* de chaînes de caractères.

- **Valeur par Défaut (default)** : La valeur par défaut est maintenant spécifiée comme *`["t2.micro", "t2.small", "t2.large"]`*, indiquant que par défaut, c'est une list contenant trois éléments de type string, soit *element[0]="t2.micro", element[1]="t2.small" et element[2]="t2.large"*.

- Pour utiliser cette variable de type list dans [01_ec2.tf](./01_ec2.tf), vous devrez l'appeler avec la syntaxe suivante

    ```hcl
    instance_type = var.ec2_instance_type[0] # pour t2.micro
    instance_type = var.ec2_instance_type[1] # pour t2.small
    instance_type = var.ec2_instance_type[2] # pour t2.large
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
    instance_type = var.ec2_instance_type[1]
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
    type        = list(string)
    default     = ["t2.micro", "t2.small", "t2.large"]
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


- Dans l'exemple ci-dessus, nous avons défini six variables :
    1. `aws_region` : région AWS par défaut à utiliser
    2. `owner` : Nom de l'ingénieur qui crée les resources
    3. `ec2_ami` : AMI EC2 AWS
    4. `ec2_instance_type` : **List** de types d'instances EC2 AWS
    5. `instance_count` : Nombre d'instances EC2 à créer
    6. `env` : Type d'environnement (PRE, PRD, DEV, UAT)


- Sortie de ***`terraform plan`*** pour ***`var.ec2_instance_type[1] (pour t2.small)`*** :
    - Vous pouvez constater le changement d'`instance_type` à *t2.small* lorsque `var.ec2_instance_type[1]` est utilisé.

        ```hcl
        $ terraform plan

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

        # aws_instance.myec2[0] will be created
        + resource "aws_instance" "myec2" {
            + ami                                  = "ami-0df435f331839b2d6"
            ...
            + instance_type                        = "t2.small"
            ...
            + tags                                 = {
                + "Name" = "Linux2023"
                + "env"  = "dev"
                }
            ...
            }

        Plan: 1 to add, 0 to change, 0 to destroy.
        ```
- De même, si vous passez `var.ec2_instance_type[0]` ou `var.ec2_instance_type[2]`, l'`instance_type` sera respectivement *t2.micro* et *t2.large*



## Références :

[Types et Valeurs](https://developer.hashicorp.com/terraform/language/expressions/types)

[Contraintes de Type *list*](https://developer.hashicorp.com/terraform/language/values/variables#list)

