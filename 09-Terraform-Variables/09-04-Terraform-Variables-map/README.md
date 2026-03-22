# Variables Terraform — Type `map(object)`

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Variables de type `map`

Dans Terraform, vous pouvez utiliser des constructeurs de types complexes comme `list` et `map` pour définir des variables.

- **`map` (ou `object`)** : un **groupe de valeurs identifiées par des étiquettes nommées**, comme `{ web = { port = 80, env = "prod" } }`.
- Les éléments d'une map sont identifiés par leur clé : `var.servers["web"]`.
- Associée à `for_each`, une map permet de créer une ressource distincte par entrée de la map.

---

## Fichiers du lab

**`00_provider.tf`**

```hcl
terraform {
  required_providers {
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

provider "local" {}
provider "random" {}
```

**`02_variables.tf`**

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

variable "servers" {
  description = "Map des serveurs avec leurs configurations"
  type = map(object({
    port = number
    env  = string
  }))
  default = {
    web = { port = 80,   env = "prod" }
    api = { port = 8080, env = "dev"  }
    db  = { port = 5432, env = "prod" }
  }
}
```

`servers` est une `map(object(...))` : chaque entrée est identifiée par une clé (`web`, `api`, `db`) et contient un objet typé avec deux champs — `port` (number) et `env` (string).

Pour accéder à une valeur :

```hcl
var.servers["web"].port   # → 80
var.servers["api"].env    # → "dev"
var.servers["db"].port    # → 5432
```

**`01_ec2.tf`**

```hcl
# Variable de type map — accès par clé
resource "local_file" "server" {
  for_each = var.servers
  filename = "${path.module}/output/${each.key}.conf"
  content  = "SERVER=${each.key}\nPORT=${each.value.port}\nENV=${each.value.env}"
}

output "server_configs" {
  value = { for k, v in local_file.server : k => v.filename }
}
```

---

## Explication de `for_each = var.servers`

Avec `for_each` sur une map, Terraform crée **une instance par entrée**. Dans chaque instance :

- `each.key` — la clé de la map (ex : `"web"`)
- `each.value` — l'objet associé (ex : `{ port = 80, env = "prod" }`)
- `each.value.port` — accès à l'attribut `port`
- `each.value.env` — accès à l'attribut `env`

| `each.key` | `each.value.port` | `each.value.env` | Fichier généré       |
| ---------- | ----------------- | ---------------- | -------------------- |
| `"api"`    | `8080`            | `"dev"`          | `output/api.conf`    |
| `"db"`     | `5432`            | `"prod"`         | `output/db.conf`     |
| `"web"`    | `80`              | `"prod"`         | `output/web.conf`    |

---

## Résultat : fichiers générés

Terraform crée trois fichiers de configuration. Exemple pour `web.conf` :

```
SERVER=web
PORT=80
ENV=prod
```

---

## Output

```hcl
output "server_configs" {
  value = { for k, v in local_file.server : k => v.filename }
}
```

Résultat :

```
server_configs = {
  "api" = "./output/api.conf"
  "db"  = "./output/db.conf"
  "web" = "./output/web.conf"
}
```

---

## Surcharger la map

Via `-var` (syntaxe JSON) :

```bash
terraform plan -var='servers={"cache":{"port":6379,"env":"prod"}}'
```

Via `terraform.tfvars` :

```hcl
servers = {
  frontend = { port = 3000, env = "staging" }
  backend  = { port = 8000, env = "staging" }
}
```

---

## Commandes Terraform

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply     # confirmer avec yes
terraform destroy   # confirmer avec yes
```

---

## Références

- [Types et Valeurs](https://developer.hashicorp.com/terraform/language/expressions/types)
- [Contraintes de type `map`](https://developer.hashicorp.com/terraform/language/expressions/types#map)
- [`for_each` avec des maps](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
