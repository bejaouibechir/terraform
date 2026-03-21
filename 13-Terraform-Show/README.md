# Commande Terraform Show

## Commande *`terraform show`*

- La commande *`terraform show`* est utilisée pour **afficher une représentation lisible par l'humain du state Terraform ou d'un fichier de plan**.
- Elle permet d'**inspecter l'état courant** de votre infrastructure gérée par Terraform ou de **visualiser le contenu d'un fichier de plan** avant de l'appliquer.
- *`terraform show`* est utile pour **vérifier l'état actuel des resources** sans avoir à ouvrir directement le fichier `terraform.tfstate`.

## Utilisation

- *`terraform show`* : Affiche le state courant de l'infrastructure
- *`terraform show <fichier-plan>`* : Affiche le contenu d'un fichier de plan spécifique (généré avec `terraform plan -out=<fichier-plan>`)

**Syntaxe** :

```hcl
# Afficher le state courant
terraform show

# Afficher un fichier de plan spécifique
terraform show <fichier-plan>
```

**Exemple** :

- Créons un VPC simple et utilisons la commande `terraform show` pour inspecter son état

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

- Dans l'exemple ci-dessus, nous créons un VPC simple et observons la sortie de `terraform show`

- Exécutons les commandes Terraform pour comprendre le comportement de `terraform show`
  
  1. ***`terraform init`*** : *Initialiser* Terraform
  2. ***`terraform validate`*** : *Valider* le code Terraform
  3. ***`terraform fmt`*** : *Formater* le code Terraform
  4. ***`terraform plan`*** : *Réviser* le plan Terraform
  5. ***`terraform apply`*** : *Créer* des Resources avec Terraform
  6. ***`terraform show`*** : *Inspecter* l'état courant de l'infrastructure

- Après l'exécution de *`terraform apply`*, utilisez *`terraform show`* pour inspecter le state courant :
  
  ```hcl
  $ terraform show
  # aws_vpc.myvpc:
  resource "aws_vpc" "myvpc" {
      arn                                  = "arn:aws:ec2:us-east-1:520974589522:vpc/vpc-0ab12cd34ef567890"
      assign_generated_ipv6_cidr_block     = false
      cidr_block                           = "10.0.0.0/16"
      default_network_acl_id               = "acl-0a1b2c3d4e5f67890"
      default_route_table_id               = "rtb-0a1b2c3d4e5f67890"
      default_security_group_id            = "sg-0a1b2c3d4e5f67890"
      dhcp_options_id                      = "dopt-7c9cef04"
      enable_dns_hostnames                 = false
      enable_dns_support                   = true
      enable_network_address_usage_metrics = false
      id                                   = "vpc-0ab12cd34ef567890"
      instance_tenancy                     = "default"
      ipv6_netmask_length                  = 0
      main_route_table_id                  = "rtb-0a1b2c3d4e5f67890"
      owner_id                             = "520974589522"
      tags                                 = {
          "Name" = "MyVPC"
      }
      tags_all                             = {
          "Name"      = "MyVPC"
          "Owner"     = "Venkatesh"
          "Terraform" = "yes"
      }
  }
  ```

- Vous pouvez également générer un fichier de plan et l'inspecter avec *`terraform show`* :
  
  ```hcl
  # Générer un fichier de plan
  terraform plan -out=monplan.tfplan
  
  # Inspecter le fichier de plan
  terraform show monplan.tfplan
  ```
  
  <details>
  <summary> <i>terraform show monplan.tfplan</i> </summary>
  
  ```hcl
  $ terraform show monplan.tfplan
  
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
  ```
  
  </details>

## Références :

Terraform Show : https://developer.hashicorp.com/terraform/cli/commands/show
