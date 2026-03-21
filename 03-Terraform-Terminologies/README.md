# Terminologies Terraform

### Provider :

- Un provider Terraform est un **plugin** qui permet à Terraform d'interagir avec un fournisseur d'infrastructure ou de service spécifique.

- Les providers sont responsables de **la traduction des configurations Terraform en appels API qui créent, modifient ou suppriment des ressources** dans l'environnement cible.

- Syntaxe d'un Provider
  
  ```hcl
  provider "nom-du-provider" {
      argument1 = "valeur1"
      argument2 = "valeur2"
      ......... = "......"
      ......... = "......"
      argumentn = "valeurn"
  }
  ```

- **Exemple :**
  
  ```hcl
  provider "aws" {
      region = "us-east-1"
  }
  ```
  
    Ici, **aws** est le provider, et il est configuré pour interagir avec les ressources AWS dans la région us-east-1.

### Resource :

- Une resource dans Terraform représente **un composant d'infrastructure** ou un **élément** chez un provider spécifique.

- Les resources sont les blocs de construction de votre infrastructure, et elles sont déclarées dans votre configuration Terraform.

- Chaque resource possède un type, un nom et un ensemble de paramètres de configuration.

- Syntaxe d'une Resource
  
  ```hcl
  resource "type" "nom" {
  argument1 = "valeur1"
  argument2 = "valeur2"
  ......... = "......"
  ......... = "......"
  argumentn = "valeurn"
  }
  ```

- **Exemple :**
  
  ```hcl
  resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  }
  ```
  
    Dans cet exemple, **aws_instance** est le type de resource, et example est le nom de la resource. Il représente une instance EC2 AWS.

### Data Sources :

- Les data sources dans Terraform vous permettent de **récupérer des informations depuis un système externe** ou des ressources existantes dans votre infrastructure.

- Elles sont ***en lecture seule*** et fournissent un moyen d'importer des données existantes dans votre configuration Terraform.

- **Exemple :**
  
  ```hcl
  data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  }
  ```
  
    Ici, **aws_ami** est une data source qui récupère des informations sur le dernier AMI Amazon Linux.

### Variables :

- Les variables dans Terraform sont des espaces réservés pour des valeurs utilisables dans toute votre configuration.

- Les variables permettent de paramétrer vos configurations, les rendant plus flexibles et réutilisables.

- Les variables peuvent être déclarées dans un fichier séparé ou directement dans la configuration principale.

- **Exemple :**
  
  ```hcl
  variable "aws_region" {
  type    = string
  default = "us-west-2"
  }
  
  resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  region        = var.aws_region
  }
  ```
  
    Dans cet exemple, **aws_region** est une variable qui définit la région AWS. Elle est référencée dans la resource **aws_instance**.

# 

### Arguments :

- Les arguments sont les **paramètres d'entrée** que vous fournissez lors de la définition d'une resource dans Terraform.

- Ils représentent les détails de configuration d'une resource spécifique.

- **Exemple :**
  
  ```hcl
  resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0" 
      instance_type = "t2.micro"
  }
  ```
  
    Dans cet exemple, **ami** et **instance_type** sont des arguments fournis lors de la création d'une resource **aws_instance**.

### Attributes :

- Les attributes représentent la **sortie** ou le **résultat** d'une resource après sa création.

- Ce sont des valeurs que vous pouvez référencer dans d'autres parties de votre configuration Terraform.

- **Exemple :**
  
  ```hcl
  output "instance_id" {
  value = aws_instance.example.id
  }
  ```
  
    Ici, **aws_instance.example.id** est un attribute de la resource **aws_instance**, et nous créons un output nommé **instance_id** pour exposer cette valeur.

### Meta-Arguments :

- Les meta-arguments sont des arguments spécifiques à Terraform.

- Les meta-arguments sont utilisés pour modifier le comportement des resources ou définir comment Terraform doit gérer certains aspects de l'infrastructure.

- Meta-arguments couramment utilisés : ***count***, ***for_each***, ***depends_on***

- **Exemple :**
  
  - ***count***
    
    ```hcl
    resource "aws_instance" "example" {
    count         = 2
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    }
    ```
    
    Dans ce cas, ***count*** est un meta-argument qui spécifie le **nombre d'instances à créer**.
  
  - ***depends_on***
    
    ```hcl
    resource "aws_instance" "web" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    }
    
    resource "aws_instance" "db" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    
    depends_on = [aws_instance.web]
    }
    ```
    
    Ici, ***depends_on*** est un meta-argument qui établit une **relation de dépendance entre des resources**.
