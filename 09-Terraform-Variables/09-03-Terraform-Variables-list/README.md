# Variables Terraform — Type `list(string)`

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Variables de type `list`

Dans Terraform, vous pouvez utiliser des constructeurs de types complexes comme `list` et `map` pour définir des variables.

- **`list` (ou `tuple`)** : une **séquence ordonnée de valeurs**, comme `["web-01", "web-02", "api-01"]`.
- Les éléments d'une list sont identifiés par des entiers consécutifs à partir de zéro : `[0]`, `[1]`, `[2]`.
- Pour itérer sur une liste avec `for_each`, il faut d'abord la convertir en `set` avec la fonction `toset()`.

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

variable "server_names" {
  description = "Liste des noms de serveurs"
  type        = list(string)
  default     = ["web-01", "web-02", "api-01"]
}
```

`server_names` est déclarée de type `list(string)`. La valeur par défaut contient trois noms de serveurs. Chaque élément est accessible par son index :

```hcl
var.server_names[0]  # → "web-01"
var.server_names[1]  # → "web-02"
var.server_names[2]  # → "api-01"
```

**`01_ec2.tf`**

```hcl
# Variable de type list — for_each sur une liste de serveurs
resource "local_file" "server" {
  for_each = toset(var.server_names)
  filename = "${path.module}/output/${each.key}.conf"
  content  = "SERVER=${each.key}\nENV=${var.environment}"
}

output "server_files" {
  value = { for k, v in local_file.server : k => v.filename }
}
```

---

## Explication de `for_each = toset(var.server_names)`

`for_each` attend un `set` ou une `map`, pas une `list`. La fonction **`toset()`** convertit la liste en ensemble (set), éliminant les doublons éventuels.

| Étape | Valeur |
| ----- | ------ |
| `var.server_names` (list) | `["web-01", "web-02", "api-01"]` |
| `toset(var.server_names)` (set) | `{"api-01", "web-01", "web-02"}` |
| `each.key` dans la boucle | `"api-01"`, `"web-01"`, `"web-02"` |

Pour chaque élément du set, Terraform crée une instance de `local_file` indépendante, identifiée par `each.key` (le nom du serveur).

---

## Résultat : fichiers générés

Avec la valeur par défaut `["web-01", "web-02", "api-01"]`, Terraform crée trois fichiers :

```
output/api-01.conf
output/web-01.conf
output/web-02.conf
```

Chaque fichier contient par exemple :

```
SERVER=web-01
ENV=dev
```

---

## Output

```hcl
output "server_files" {
  value = { for k, v in local_file.server : k => v.filename }
}
```

Cet output produit une map associant chaque nom de serveur à son chemin de fichier :

```
server_files = {
  "api-01" = "./output/api-01.conf"
  "web-01" = "./output/web-01.conf"
  "web-02" = "./output/web-02.conf"
}
```

---

## Surcharger la liste

Via la ligne de commande :

```bash
terraform plan -var='server_names=["db-01","cache-01"]'
```

Via `terraform.tfvars` :

```hcl
server_names = ["frontend", "backend", "worker"]
environment  = "staging"
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
- [Contraintes de type `list`](https://developer.hashicorp.com/terraform/language/values/variables#list)
- [Fonction `toset()`](https://developer.hashicorp.com/terraform/language/functions/toset)
- [`for_each` avec des sets](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
