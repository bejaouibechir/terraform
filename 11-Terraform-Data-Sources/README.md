# Data Sources Terraform

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Data Sources

- Les data resources dans Terraform vous permettent de **récupérer des informations** ou d'**interroger des ressources existantes en dehors de la configuration**.

- Les data resources **ne créent ni ne gèrent d'infrastructure**. Elles fournissent un **moyen de référencer des données externes**.

- **Données Immuables :** Les data resources offrent un moyen d'interagir avec des données externes, mais elles **ne modifient pas ces données**. **Elles sont en lecture seule**.

- **Blocs Data :** La structure d'un bloc data est similaire à celle d'un resource block, mais avec le mot-clé **`data`**.

- **Valeurs Dynamiques :** Vous pouvez utiliser des valeurs dynamiques provenant des data resources à divers endroits dans votre configuration Terraform.

**Syntaxe** :

```hcl
data "type" "nom" {
    argument1 = "valeur1"
    argument2 = "valeur2"
}
```

Référence dans la configuration :

```hcl
data.<type>.<nom>.<attribut>
```

## Analogie avec AWS

| Data Source léger (ce lab) | Équivalent AWS |
|---|---|
| `data.http` — appel vers api.ipify.org | `data.aws_ami` — récupère un AMI depuis AWS |
| `data.local_file` — lit un fichier JSON local | `data.aws_vpc` — interroge un VPC existant |

## Exemple Pratique

Ce module démontre deux data sources :
1. **`data.http`** — effectue un appel HTTP vers `api.ipify.org` pour récupérer l'IP publique de la machine
2. **`data.local_file`** — lit un fichier JSON local (`existing_config.json`) qui simule une configuration existante

### Structure des Fichiers

```
11-Terraform-Data-Sources/
├── 00_provider.tf
├── 01_resources.tf
├── 02_variables.tf
├── 03_data.tf
├── 04_outputs.tf
├── existing_config.json   (fichier existant, lu par data source)
└── output/
    └── instance_info.json (créé par Terraform)
```

### Fichier `existing_config.json` (pré-existant)

```json
{
  "environment": "production",
  "region": "eu-west-1",
  "team": "infrastructure",
  "created_by": "admin"
}
```

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "http" {}
provider "local" {}
provider "random" {}
```

[02_variables.tf](./02_variables.tf)

```hcl
variable "environment" {
  description = "Nom de l'environnement"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Nom de l'ingénieur responsable"
  type        = string
  default     = "Venkatesh"
}
```

[03_data.tf](./03_data.tf)

```hcl
# -------------------------------------------------------
# Data Source 1 : appel HTTP vers une API publique
# Simule la récupération d'informations externes
# comme "data aws_ami" ou "data aws_availability_zones"
# -------------------------------------------------------
data "http" "public_ip" {
  url = "https://api.ipify.org?format=json"

  request_headers = {
    Accept = "application/json"
  }
}

# -------------------------------------------------------
# Data Source 2 : lecture d'un fichier local existant
# Simule "data aws_vpc" — interroger une ressource existante
# -------------------------------------------------------
data "local_file" "existing_config" {
  filename = "${path.module}/existing_config.json"
}
```

[01_resources.tf](./01_resources.tf)

```hcl
resource "random_id" "instance_id" {
  byte_length = 4
}

# Utilise les données récupérées par le data source HTTP
resource "local_file" "instance_info" {
  filename = "${path.module}/output/instance_info.json"
  content = jsonencode({
    instance_id     = random_id.instance_id.hex
    environment     = var.environment
    public_ip       = jsondecode(data.http.public_ip.response_body).ip
    existing_config = jsondecode(data.local_file.existing_config.content)
  })
}
```

[04_outputs.tf](./04_outputs.tf)

```hcl
output "public_ip" {
  description = "IP publique récupérée via data source HTTP"
  value       = jsondecode(data.http.public_ip.response_body).ip
}

output "existing_config" {
  description = "Contenu du fichier de configuration existant (data source local)"
  value       = jsondecode(data.local_file.existing_config.content)
}

output "instance_id" {
  description = "ID de l'instance générée"
  value       = random_id.instance_id.hex
}
```

## Exécution Pas à Pas

1. ***`terraform init`*** : *Initialiser* Terraform
2. ***`terraform validate`*** : *Valider* le code Terraform
3. ***`terraform fmt`*** : *Formater* le code Terraform
4. ***`terraform plan`*** : *Réviser* le plan Terraform
5. ***`terraform apply`*** : *Créer* les Resources

<details>
<summary><i>terraform apply</i></summary>

```shell
$ terraform apply -auto-approve

data.http.public_ip: Reading...
data.http.public_ip: Read complete after 1s
data.local_file.existing_config: Reading...
data.local_file.existing_config: Read complete after 0s [id=...]

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_id.instance_id will be created
  + resource "random_id" "instance_id" {
      + byte_length = 4
      + hex         = (known after apply)
    }

  # local_file.instance_info will be created
  + resource "local_file" "instance_info" {
      + filename = "./output/instance_info.json"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + existing_config = {
      + created_by  = "admin"
      + environment = "production"
      + region      = "eu-west-1"
      + team        = "infrastructure"
    }
  + instance_id     = (known after apply)
  + public_ip       = "203.0.113.42"

random_id.instance_id: Creating...
random_id.instance_id: Creation complete after 0s [id=b7e1f3a9]
local_file.instance_info: Creating...
local_file.instance_info: Creation complete after 0s [id=...]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

existing_config = {
  "created_by"  = "admin"
  "environment" = "production"
  "region"      = "eu-west-1"
  "team"        = "infrastructure"
}
instance_id     = "b7e1f3a9"
public_ip       = "203.0.113.42"
```

</details>

### Points clés à observer

- Les **data sources sont lus avant** les resources (`Read complete` avant `Creating...`).
- `data.http.public_ip` effectue un appel réseau réel vers `api.ipify.org` — l'IP affichée est celle de votre machine.
- `data.local_file.existing_config` lit `existing_config.json` et le contenu est parsé avec `jsondecode()`.
- Le fichier `output/instance_info.json` **combine** les deux data sources avec la resource `random_id`.

### Contenu du fichier `output/instance_info.json` généré

```json
{
  "environment": "dev",
  "existing_config": {
    "created_by": "admin",
    "environment": "production",
    "region": "eu-west-1",
    "team": "infrastructure"
  },
  "instance_id": "b7e1f3a9",
  "public_ip": "203.0.113.42"
}
```

### Nettoyage

```shell
terraform destroy -auto-approve
```

## Références :

- [Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)
- [Provider http — data source http](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http)
- [Provider local — data source local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file)
