> ⚙️ Ce lab utilise **LocalStack** — aucune credential AWS réelle requise.

# Démonstration VPC Terraform

Ce lab crée un **VPC AWS** avec Terraform en ciblant LocalStack, un émulateur AWS local tournant dans Docker. Aucun compte AWS n'est nécessaire.

---

### Étape 01 : Créer un fichier `00_provider.tf` pour inclure les blocs terraform et provider

Le provider pointe vers LocalStack via `http://localhost:4566`. Les credentials `test/test` sont fictifs et acceptés par LocalStack.

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
  region = "us-east-1"

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
      terraform = "yes"
      project   = "terraform-learning"
    }
  }
}
```

[00_provider.tf](00_provider.tf)

---

### Étape 02 : Créer un fichier `01_vpc.tf` avec un resource block pour créer un VPC AWS

- [Resource Terraform AWS VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

```hcl
resource "aws_vpc" "appvpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "myapp-vpc"
    }
}
```

[01_vpc.tf](01_vpc.tf)

---

### Étape 03 : Démarrer LocalStack

LocalStack doit être actif **avant** d'exécuter toute commande Terraform.

```shell
docker run -d -p 4566:4566 localstack/localstack
```

Vérifiez que LocalStack répond :

```shell
curl http://localhost:4566/_localstack/health
```

Vous devriez obtenir une réponse JSON indiquant les services disponibles (notamment `ec2`).

---

### Étape 04 : Exécuter les Commandes Terraform

#### Initialiser Terraform

```shell
terraform init
```

#### Valider les Fichiers de Configuration Terraform

```shell
terraform validate
```

#### Exécuter le Plan Terraform

```shell
terraform plan
```

<details>
<summary> <i>terraform plan</i> </summary>

```shell
$ terraform plan

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.appvpc will be created
  + resource "aws_vpc" "appvpc" {
      + cidr_block = "10.0.0.0/16"
      + id         = (known after apply)
      + tags       = {
          + "Name"      = "myapp-vpc"
          + "project"   = "terraform-learning"
          + "terraform" = "yes"
        }
      + tags_all   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

</details>

#### Déployer les Resources avec Terraform

```shell
terraform apply
```

ou

```shell
terraform apply -auto-approve
```

(pour éviter la confirmation — non recommandé pour les débutants)

<details>
<summary> <i>terraform apply</i> </summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.appvpc will be created
  + resource "aws_vpc" "appvpc" {
      + cidr_block = "10.0.0.0/16"
      + id         = (known after apply)
      + tags       = {
          + "Name"      = "myapp-vpc"
          + "project"   = "terraform-learning"
          + "terraform" = "yes"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

aws_vpc.appvpc: Creating...
aws_vpc.appvpc: Creation complete after 1s [id=vpc-0a1b2c3d4e5f00001]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

</details>

> L'ID `vpc-0a1b2c3d4e5f00001` est généré par LocalStack. Il ne correspond à aucune infrastructure AWS réelle.

---

### Étape 05 : Nettoyage

#### Détruire les Resources Terraform

```shell
terraform destroy
```

ou

```shell
terraform destroy -auto-approve
```

(pour éviter la confirmation — non recommandé pour les débutants)

#### Supprimer les Fichiers Terraform du répertoire courant

##### Linux / macOS

```shell
rm -rf .terraform*
rm -rf terraform.tfstate*
```

##### Windows

Supprimer le répertoire `.terraform/`, le fichier `.terraform.lock.hcl` et les fichiers `terraform.tfstate*` du dossier.

---

## Références

- [Terraform Providers](https://www.terraform.io/docs/configuration/providers.html)
- [Documentation du Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Resource Terraform AWS VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [LocalStack — Documentation officielle](https://docs.localstack.cloud/)
