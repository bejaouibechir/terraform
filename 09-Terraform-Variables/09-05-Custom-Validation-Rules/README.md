# Variables Terraform

## Règles de Validation Personnalisées pour les Variables d'Entrée Terraform


- Les règles de validation personnalisées sont un moyen d'**imposer des conditions spécifiques** ou des contraintes sur les valeurs de vos attributs de resource.

- Ces règles vous permettent de **définir des vérifications qui doivent être satisfaites avant que Terraform accepte la configuration**.

- **Règles de Validation** : Ce sont des conditions que vous définissez pour vos attributs de resource. Elles peuvent être aussi simples ou complexes que vos exigences.

- **Validation Personnalisée** : Terraform vous permet de créer vos propres règles de validation en utilisant le bloc ***`validation`*** dans une définition de resource.

- **Cas d'usage** :
    - S'assurer que les **paramètres requis sont définis**.
    - Vérifier que les valeurs répondent à des critères spécifiques.
    - S'assurer que **certaines conditions sont satisfaites avant la création de la resource**.

- **Avantages** :
    - Ajoute une couche de contrôle supplémentaire sur votre infrastructure.
    - Aide à **détecter les erreurs de configuration potentielles** tôt dans le processus de déploiement.
    - Fournit des messages d'erreur significatifs pour faciliter le dépannage.

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
    region = var.aws_region

    default_tags {
        tags = {
        Terraform = "yes"
        Owner = var.owner
        }
    }
    }
    ```

    [01_ec2.tf](./01_ec2.tf)
    ```hcl
    resource "aws_instance" "myec2" {
    ami = var.ec2_ami
    instance_type = var.ec2_instance_type

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
    validation {
        condition = length(var.ec2_ami) > 4 && substr(var.ec2_ami, 0,4) == "ami-"
        error_message = "La valeur de l'ID AMI EC2 doit être un ID AMI valide, commençant par \"ami-\"."
    }
    }

    variable "ec2_instance_type" {
    description = "Type d'instance EC2"
    type        = string
    default     = "t2.micro"
    }

    variable "env" {
    description = "Type d'environnement"
    type        = string
    default     = "dev"
    }
    ```


- Dans l'exemple ci-dessus,
    la variable `ec2_ami` : nous définissons des règles de validation personnalisées qui signifient que l'ID `ami` doit avoir une ***longueur > 4*** et commencer toujours par *`ami-`*


Pour tester les règles de validation personnalisées, changeons l'ID ami pour qu'il commence différemment et observons ce que `terraform` signale

```hcl
    variable "ec2_ami" {
    description = "AMI EC2 AWS Amazon Linux 2023"
    type        = string
    #default     = "ami-0df435f331839b2d6" # Amazon Linux 2023
    default     = "xyz-0df435f331839b2d6"
    validation {
        condition = length(var.ec2_ami) > 4 && substr(var.ec2_ami, 0,4) == "ami-"
        error_message = "La valeur de l'ID AMI EC2 doit être un ID AMI valide, commençant par \"ami-\"."
    }
    }
   ```


- Sortie de ***`terraform plan`***

    - Vous pouvez constater les règles de validation en action et l'`error_message` affiché pour effectuer la correction

    ```hcl
    $ terraform plan

    Planning failed. Terraform encountered an error while generating this plan.

    ╷
    │ Error: Invalid value for variable
    │
    │   on 02_variables.tf line 13:
    │   13: variable "ec2_ami" {
    │     ├────────────────
    │     │ var.ec2_ami is "xyz-0df435f331839b2d6"
    │
    │ La valeur de l'ID AMI EC2 doit être un ID AMI valide, commençant par "ami-".
    │
    │ This was checked by the validation rule at 02_variables.tf:18,3-13.
    ```


## Références :

[Conditions Personnalisées Terraform](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions)


