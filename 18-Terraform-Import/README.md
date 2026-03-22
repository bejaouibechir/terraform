> ⚙️ Ce lab utilise **LocalStack** — aucune credential AWS réelle requise.

# Terraform Import

## Intégrer votre Infrastructure Existante sous IaC

- La commande **`terraform import`** est utilisée pour **importer une infrastructure existante dans votre state Terraform**.
- **`terraform import`** vous permet de **placer des resources sous gestion Terraform sans avoir à les recréer**.
- Cas d'usage typique : votre équipe a créé des resources manuellement (via CLI, scripts, ou d'autres outils) **avant** d'adopter Terraform — vous souhaitez maintenant les gérer via IaC sans interruption de service.
- Dans ce lab, la resource "existante" est un VPC créé directement dans LocalStack via `awslocal`, l'outil CLI dédié à LocalStack.

## Étapes du Workflow d'Import

| Étape | Action                                                                          |
| ----- | ------------------------------------------------------------------------------- |
| 1     | **Créer** la resource manuellement dans LocalStack et récupérer son ID unique   |
| 2     | **Déclarer** un bloc resource vide dans un fichier `.tf`                        |
| 3     | **Exécuter** `terraform import` pour importer la resource dans le state         |
| 4     | **Inspecter** le state avec `terraform show` pour récupérer les attributs réels |
| 5     | **Mettre à jour** le fichier `.tf` avec la configuration complète               |
| 6     | **Vérifier** avec `terraform plan` qu'il n'y a aucun changement détecté         |

---

## Exemple Pratique : Import d'un VPC Existant

**Scénario** : Un VPC a été créé directement dans LocalStack (sans Terraform). Nous souhaitons le placer sous gestion Terraform.

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

[03_outputs.tf](./03_outputs.tf)

```hcl
output "vpc_id" {
  description = "ID du VPC importé"
  value       = aws_vpc.imported.id
}

output "vpc_cidr" {
  description = "CIDR du VPC importé"
  value       = aws_vpc.imported.cidr_block
}

output "vpc_arn" {
  description = "ARN du VPC importé"
  value       = aws_vpc.imported.arn
}
```

---

## Exécution Pas à Pas

### Étape 1 — Démarrer LocalStack

```shell
docker run -d -p 4566:4566 localstack/localstack
```

Vérifiez que LocalStack répond :

```shell
curl http://localhost:4566/_localstack/health
```

### Étape 2 — Créer le VPC manuellement dans LocalStack

Utilisez `awslocal` (wrapper CLI de LocalStack autour d'`awscli`) pour créer un VPC directement dans LocalStack, **sans Terraform** :

```shell
awslocal ec2 create-vpc --cidr-block 10.0.0.0/16
```

<details>
<summary> <i>awslocal ec2 create-vpc</i> </summary>

```shell
$ awslocal ec2 create-vpc --cidr-block 10.0.0.0/16
{
    "Vpc": {
        "CidrBlock": "10.0.0.0/16",
        "VpcId": "vpc-0a1b2c3d4e5f00042",
        "State": "available",
        "DhcpOptionsId": "dopt-00000000",
        "InstanceTenancy": "default",
        "IsDefault": false
    }
}
```

</details>

- Notez l'ID retourné : **`vpc-0a1b2c3d4e5f00042`**

Vous pouvez également lister les VPCs existants dans LocalStack :

```shell
awslocal ec2 describe-vpcs --query "Vpcs[*].{ID:VpcId,CIDR:CidrBlock}" --output table
```

```shell
----------------------------------------------
|              DescribeVpcs                  |
+----------------------+---------------------+
|        CIDR          |         ID          |
+----------------------+---------------------+
|  10.0.0.0/16         | vpc-0a1b2c3d4e5f00042 |
+----------------------+---------------------+
```

---

### Étape 3 — Initialiser Terraform et Déclarer un Bloc Vide

```shell
terraform init
```

Créez [02_vpc.tf](./02_vpc.tf) avec un **bloc resource vide** — Terraform a besoin de cette déclaration pour pouvoir importer :

```hcl
resource "aws_vpc" "imported" {

}
```

> **Remarque :** Le bloc est intentionnellement vide à cette étape. Les attributs seront renseignés après l'import.

---

### Étape 4 — Exécuter `terraform import`

Exécutez la commande `terraform import` en précisant **le type de resource**, **le nom local** et **l'ID LocalStack** :

```shell
terraform import aws_vpc.imported vpc-0a1b2c3d4e5f00042
```

<details>
<summary> <i>terraform import</i> </summary>

```shell
$ terraform import aws_vpc.imported vpc-0a1b2c3d4e5f00042

aws_vpc.imported: Importing from ID "vpc-0a1b2c3d4e5f00042"...
aws_vpc.imported: Import prepared!
  Prepared aws_vpc for import
aws_vpc.imported: Refreshing state... [id=vpc-0a1b2c3d4e5f00042]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

</details>

- Le VPC est maintenant **présent dans le fichier state** mais la configuration `.tf` est toujours vide.

---

### Étape 5 — Inspecter le State avec `terraform show`

Utilisez `terraform show` pour afficher tous les **attributs réels** du VPC importé depuis LocalStack :

```shell
terraform show
```

<details>
<summary> <i>terraform show</i> </summary>

```shell
$ terraform show
# aws_vpc.imported:
resource "aws_vpc" "imported" {
    arn                                  = "arn:aws:ec2:us-east-1:000000000000:vpc/vpc-0a1b2c3d4e5f00042"
    assign_generated_ipv6_cidr_block     = false
    cidr_block                           = "10.0.0.0/16"
    default_network_acl_id               = "acl-00000000"
    default_route_table_id               = "rtb-00000000"
    default_security_group_id            = "sg-00000000"
    dhcp_options_id                      = "dopt-00000000"
    enable_dns_hostnames                 = false
    enable_dns_support                   = true
    enable_network_address_usage_metrics = false
    id                                   = "vpc-0a1b2c3d4e5f00042"
    instance_tenancy                     = "default"
    ipv6_netmask_length                  = 0
    main_route_table_id                  = "rtb-00000000"
    owner_id                             = "000000000000"
    tags                                 = {
        "Name" = "MyVPC-Existing"
    }
    tags_all                             = {
        "Name"      = "MyVPC-Existing"
        "Owner"     = "Venkatesh"
        "Terraform" = "yes"
    }
}
```

</details>

> L'`owner_id` `000000000000` est l'identifiant de compte fictif utilisé par LocalStack.

---

### Étape 6 — Mettre à Jour le Fichier `02_vpc.tf`

En vous basant sur la sortie de `terraform show`, **renseignez le bloc resource** avec les attributs réels du VPC importé. Le fichier [02_vpc.tf](./02_vpc.tf) final correspond à :

```hcl
# Étape 1 - Déclaration vide avant l'import
# (bloc vide requis avant d'exécuter terraform import)
#
# resource "aws_vpc" "imported" {
#
# }

# Étape 2 - Configuration complète après l'import et terraform show
# (à renseigner manuellement après avoir exécuté terraform show)
resource "aws_vpc" "imported" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false
  instance_tenancy     = "default"

  tags = {
    Name = "MyVPC-Existing"
  }
}
```

> **Remarque :** Renseignez uniquement les attributs **configurables** (arguments). Les attributs calculés par LocalStack (`id`, `arn`, `owner_id`, etc.) sont gérés automatiquement par Terraform et ne doivent pas figurer dans le bloc resource.

---

### Étape 7 — Vérifier avec `terraform plan`

Exécutez `terraform plan` pour confirmer que Terraform ne détecte **aucun changement** entre votre configuration et l'infrastructure dans LocalStack :

```shell
terraform plan
```

<details>
<summary> <i>terraform plan</i> </summary>

```shell
$ terraform plan
aws_vpc.imported: Refreshing state... [id=vpc-0a1b2c3d4e5f00042]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration
and found no differences, so no changes are needed.
```

</details>

---

### Étape 8 — Appliquer et Vérifier les Outputs

```shell
terraform apply
```

<details>
<summary> <i>terraform apply</i> </summary>

```shell
$ terraform apply
aws_vpc.imported: Refreshing state... [id=vpc-0a1b2c3d4e5f00042]

No changes. Your infrastructure matches the configuration.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

vpc_arn  = "arn:aws:ec2:us-east-1:000000000000:vpc/vpc-0a1b2c3d4e5f00042"
vpc_cidr = "10.0.0.0/16"
vpc_id   = "vpc-0a1b2c3d4e5f00042"
```

</details>

- Le message ***No changes*** confirme que votre fichier `.tf` correspond exactement à l'infrastructure dans LocalStack.
- Le VPC est maintenant **entièrement géré par Terraform**.

---

## Remarque Importante

- `terraform import` **importe uniquement dans le state** — il ne génère pas automatiquement le code `.tf`.
- Vous devez **toujours mettre à jour manuellement** votre fichier de configuration après l'import.
- Si `terraform plan` détecte des différences après l'import, ajustez votre fichier `.tf` jusqu'à obtenir ***No changes***.

---

## Récapitulatif

```shell
# 1. Démarrer LocalStack
docker run -d -p 4566:4566 localstack/localstack

# 2. Créer le VPC dans LocalStack (simulation d'une resource pré-existante)
awslocal ec2 create-vpc --cidr-block 10.0.0.0/16

# 3. Initialiser Terraform
terraform init

# 4. Déclarer un bloc vide dans 02_vpc.tf, puis importer
terraform import aws_vpc.imported <VPC_ID>

# 5. Inspecter les attributs importés
terraform show

# 6. Mettre à jour 02_vpc.tf avec la configuration complète

# 7. Vérifier qu'il n'y a aucun changement
terraform plan

# 8. Appliquer pour confirmer la gestion Terraform
terraform apply
```

## Références :

https://developer.hashicorp.com/terraform/cli/import

https://developer.hashicorp.com/terraform/cli/import/usage

https://docs.localstack.cloud/

https://github.com/localstack/awscli-local
