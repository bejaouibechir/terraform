# Variables Terraform

Explorons :

- Les variables Terraform avec l'option `default`
- La surcharge des valeurs `default` avec l'option `-var`
- La surcharge des valeurs `default` avec les variables d'environnement

---

## Variables Terraform avec l'option `default`

Dans Terraform, les variables sont des espaces réservés qui permettent d'injecter des données dans vos configurations, rendant votre code plus flexible et réutilisable.

- Les variables sont des conteneurs pour **stocker et gérer des valeurs** : texte, nombres ou données complexes.
- Elles permettent de **paramétrer vos configurations** : régions, types d'instances, noms d'environnements...
- Elles sont déclarées avec le bloc `variable` en spécifiant le **nom**, le **type** et une **valeur par défaut** optionnelle.
- Elles rendent votre code réutilisable dans différents environnements : `prd`, `pre`, `uat`, `dev`.

### Priorités des variables

![](C:\Users\DELL\Desktop\terraform-beginners-guide\09-Terraform-Variables\imgs\variable-priority.jpg)

### Cas 1 — Valeur par défaut (aucune surcharge)

La variable `instance_type` est déclarée avec une valeur `default`.
Terraform l'utilise telle quelle si aucune autre source ne la redéfinit.

```hcl
# variables.tf
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

```bash
terraform plan
# → instance_type = "t2.micro"  ← valeur default utilisée
```

---

### Cas 2 — Surcharge via `terraform.tfvars` (priorité 2)

Un fichier `terraform.tfvars` écrase la valeur `default`.

```hcl
# terraform.tfvars
instance_type = "t3.small"
```

```bash
terraform plan
# → instance_type = "t3.small"  ← tfvars l'emporte sur default
```

---

### Cas 3 — Surcharge via `*.auto.tfvars` (priorité 4)

Un fichier `prod.auto.tfvars` est chargé automatiquement et écrase `terraform.tfvars`.

```hcl
# prod.auto.tfvars
instance_type = "t3.large"
```

```bash
terraform plan
# → instance_type = "t3.large"  ← auto.tfvars l'emporte sur tfvars
```

> Les fichiers `*.auto.tfvars` sont chargés par **ordre lexical**.
> `aaa.auto.tfvars` est chargé avant `zzz.auto.tfvars` et sera écrasé par lui.

---

### Cas 4 — Surcharge via variable d'environnement `TF_VAR_` (priorité 1)

```bash
export TF_VAR_instance_type=t2.large

terraform plan
# → instance_type = "t2.large"  ← TF_VAR_ l'emporte sur default
#                                   mais PAS sur tfvars ni auto.tfvars

unset TF_VAR_instance_type       # supprimer après usage
```

> Attention : les variables d'environnement ont la **priorité la plus faible**.
> Elles sont écrasées par `terraform.tfvars`, `*.auto.tfvars` et `-var`.

---

### Cas 5 — Surcharge via `-var` en ligne de commande (priorité 5)

```bash
terraform plan -var="instance_type=m4.large"
# → instance_type = "m4.large"  ← -var écrase toutes les autres sources
```

Plusieurs variables à la fois :

```bash
terraform plan \
  -var="instance_type=m4.large" \
  -var="instance_count=3"
# → instance_type  = "m4.large"
# → instance_count = 3
```

---

### Cas 6 — Conflit entre plusieurs sources simultanées

Toutes les sources actives en même temps — Terraform retient
**uniquement la valeur de la source ayant la priorité la plus haute**.

```hcl
# variables.tf         → default        = "t2.micro"    (fallback)
# terraform.tfvars     → instance_type  = "t3.small"    (priorité 2)
# prod.auto.tfvars     → instance_type  = "t3.large"    (priorité 4)
```

```bash
export TF_VAR_instance_type=t2.large   # priorité 1

terraform plan -var="instance_type=m4.xlarge"   # priorité 5

# → instance_type = "m4.xlarge"  ← -var gagne toujours
```

---

### Cas 7 — Sauvegarder et réutiliser un plan (`-out`)

```bash
# Générer le plan et le sauvegarder
terraform plan -var="instance_type=m4.large" -out=tfplan.plan

# Appliquer depuis le fichier plan — sans demande de confirmation
terraform apply tfplan.plan
```

> Avec un fichier plan, `terraform apply` **n'affiche pas de prompt** `yes/no`
> et applique exactement ce qui a été planifié.

### Cas d'emploi des variables

### Exemple

**`00_provider.tf`**

```hcl
terraform {
  required_version = "~> 1.14"
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

**`01_ec2.tf`**

```hcl
resource "aws_instance" "myec2" {
  # Utilisation de variables pour les arguments
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  count         = var.instance_count

  tags = {
    Name = "Linux2023"
  }
}
```

**`02_variables.tf`**

```hcl
variable "aws_region" {
  description = "Région AWS dans laquelle les ressources seront créées"
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Nom de l'ingénieur qui crée les ressources"
  type        = string
  default     = "Venkatesh"
}

variable "ec2_ami" {
  description = "AMI EC2 AWS Amazon Linux 2023"
  type        = string
  default     = "ami-0df435f331839b2d6"
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

Cinq variables sont définies :

1. `aws_region` — région AWS à utiliser
2. `owner` — nom de l'ingénieur responsable des ressources
3. `ec2_ami` — identifiant de l'AMI Amazon Linux 2023
4. `ec2_instance_type` — type d'instance EC2
5. `instance_count` — nombre d'instances EC2 à créer

Chaque variable possède un **type** (`string` ou `number`) et une **valeur par défaut**.

### Commandes Terraform

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply     # confirmer avec yes
terraform destroy   # confirmer avec yes
```

### Sortie de `terraform plan` (valeurs par défaut)

```
Terraform will perform the following actions:

  # aws_instance.myec2[0] will be created
  + resource "aws_instance" "myec2" {
      + ami           = "ami-0df435f331839b2d6"
      + instance_type = "t2.micro"
      + tags_all = {
          + "Name"      = "Linux2023"
          + "Owner"     = "Venkatesh"
          + "Terraform" = "yes"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

---

## Surcharge des valeurs `default` avec l'option `-var`

L'option `-var` en ligne de commande permet de **remplacer la valeur par défaut** d'une variable sans modifier le code.

- Syntaxe : `terraform plan -var="nom_variable=nouvelle_valeur"`
- Plusieurs variables peuvent être surchargées en enchaînant les options `-var`
- L'option `-var-file` permet de passer un fichier de variables entier

### Exemple — surcharger `ec2_instance_type` et `instance_count`

```bash
# Surcharger directement en ligne de commande
terraform plan -var="ec2_instance_type=m4.large" -var="instance_count=2"
```

### Sortie de `terraform plan` (avec `-var`)

```
Terraform will perform the following actions:

  # aws_instance.myec2[0] will be created
  + resource "aws_instance" "myec2" {
      + ami           = "ami-0df435f331839b2d6"
      + instance_type = "m4.large"   # valeur surchargée
    }

  # aws_instance.myec2[1] will be created
  + resource "aws_instance" "myec2" {
      + ami           = "ami-0df435f331839b2d6"
      + instance_type = "m4.large"   # valeur surchargée
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

> Terraform a bien surchargé `ec2_instance_type` (`t2.micro` → `m4.large`) et `instance_count` (`1` → `2`).

### Utiliser `-out` pour sauvegarder le plan

```bash
# Générer et sauvegarder le plan dans un fichier
terraform plan -var="ec2_instance_type=m4.large" -var="instance_count=2" -out tfplan.plan

# Appliquer depuis le fichier plan (sans demande de confirmation)
terraform apply tfplan.plan
```

> Lorsque `terraform apply` est utilisé avec un fichier plan, **il ne demande pas de confirmation** et s'applique immédiatement.

---

## Surcharge des valeurs `default` avec les variables d'environnement

Dans Terraform, les variables d'environnement permettent de **surcharger les variables d'entrée sans modifier le code** ni utiliser la ligne de commande.

- Préfixer le nom de la variable avec **`TF_VAR_`** : `TF_VAR_nom_variable=valeur`
- Utiliser la commande `export` pour définir la variable d'environnement (Linux/macOS)
- Utiliser `unset` pour supprimer la variable d'environnement

### Exemple — surcharger `ec2_instance_type` et `owner`

```bash
# Définir les variables d'environnement
export TF_VAR_ec2_instance_type=t2.large
export TF_VAR_owner=Amar

# Vérifier les valeurs
echo $TF_VAR_ec2_instance_type, $TF_VAR_owner
# → t2.large, Amar
```

### Sortie de `terraform plan` (avec variables d'environnement)

```
Terraform will perform the following actions:

  # aws_instance.myec2[0] will be created
  + resource "aws_instance" "myec2" {
      + ami           = "ami-0df435f331839b2d6"
      + instance_type = "t2.large"   # valeur surchargée via TF_VAR_
      + tags_all = {
          + "Name"      = "Linux2023"
          + "Owner"     = "Amar"     # valeur surchargée via TF_VAR_
          + "Terraform" = "yes"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

### Supprimer les variables d'environnement

```bash
unset TF_VAR_ec2_instance_type
unset TF_VAR_owner

# Vérifier la suppression (résultat vide)
echo $TF_VAR_ec2_instance_type, $TF_VAR_owner
```

---

## Priorité des variables Terraform

![Priorité des variables Terraform](./imgs/variable-priority.png)

Terraform charge les variables dans l'ordre suivant — **la source du bas peut être écrasée par toutes celles du dessus** :

| Priorité                 | Source                                                          | Exemple                                  |
| ------------------------ | --------------------------------------------------------------- | ---------------------------------------- |
| **5** *(la plus haute)*  | Options `-var` et `-var-file` en ligne de commande              | `terraform plan -var="region=eu-west-1"` |
| **4**                    | Fichiers `*.auto.tfvars` / `*.auto.tfvars.json` (ordre lexical) | `prod.auto.tfvars`                       |
| **3**                    | Fichier `terraform.tfvars.json`                                 | `{ "region": "eu-west-1" }`              |
| **2**                    | Fichier `terraform.tfvars`                                      | `region = "eu-west-1"`                   |
| **1** *(la plus faible)* | Variables d'environnement `TF_VAR_`                             | `export TF_VAR_region=eu-west-1`         |

> La même variable ne peut pas recevoir plusieurs valeurs au sein d'une **seule et même source**. En cas de conflit entre sources, Terraform utilise la valeur de la source ayant la **priorité la plus haute**.

---

## Références

- [Variables d'entrée — Terraform docs](https://developer.hashicorp.com/terraform/language/values/variables)
- [Variable d'environnement TF_VAR_name](https://developer.hashicorp.com/terraform/cli/config/environment-variables#tf_var_name)
- [Priorité de définition des variables](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)
