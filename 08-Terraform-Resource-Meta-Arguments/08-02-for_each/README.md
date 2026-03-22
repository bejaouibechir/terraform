> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Meta-Argument Terraform : *`for_each`*

### Meta-Argument ***`for_each`***

- Le meta-argument ***for_each*** est utilisé pour **créer plusieurs instances d'une resource à partir des éléments d'une ***`map`*** ou d'un ***`set`*****.
- ***for_each*** offre de la flexibilité pour **gérer des resources avec différentes configurations**.
- Lorsque vous définissez un resource block avec le meta-argument *for_each*, vous pouvez fournir une *`map`* ou un *`set`* qui décrit la configuration de chaque instance de resource.
- Terraform créera alors **une resource distincte pour chaque élément de la map ou du set**.

- ***`map`***
  - Une ***map*** est une structure de données qui stocke des ***`paires clé-valeur`***.
  - **Chaque clé dans la map est unique**, et **elle est associée à une valeur spécifique**.
  - Exemple :
    ```hcl
    {
      web = { port = 80,   env = "prod"    }
      api = { port = 8080, env = "staging" }
      db  = { port = 5432, env = "prod"    }
    }
    ```
    - Vous avez des noms de serveurs (clés) et leurs propriétés (valeurs). Chaque clé est unique et associée à une valeur.
    - **Les clés d'une map sont uniques**, vous **ne pouvez pas avoir deux entrées avec la même clé**.

- ***`set`***
  - Un *set* est une structure de données qui **stocke une collection d'éléments distincts**.
  - Dans un *set*, **il n'y a pas de doublons**, et **l'ordre des éléments n'a pas d'importance**.
  - Les sets **garantissent automatiquement l'unicité**. Si vous ajoutez un élément qui existe déjà, il ne sera pas dupliqué.
  - Exemple :
    ```hcl
    toset(["dev", "staging", "prod"])
    ```

- **Remarque** : Un **bloc de resource ou de module donné ne peut pas utiliser à la fois ***count***** et ***for_each***.

---

### Exemple : ***`for_each`*** sur un set et une map

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}
```

[01_for_each.tf](./01_for_each.tf)

```hcl
# Meta-argument FOR_EACH avec un set de strings
# Équivaut à créer un Security Group par environnement

locals {
  environments = toset(["dev", "staging", "prod"])

  servers = {
    web = { port = 80,   env = "prod"    }
    api = { port = 8080, env = "staging" }
    db  = { port = 5432, env = "prod"    }
  }
}

# FOR_EACH sur un set
resource "local_file" "env_config" {
  for_each = local.environments
  filename = "${path.module}/output/${each.key}/config.conf"
  content  = "ENV=${each.key}\nMANAGED_BY=terraform"
}

# FOR_EACH sur une map
resource "local_file" "server_config" {
  for_each = local.servers
  filename = "${path.module}/output/servers/${each.key}.conf"
  content  = "SERVER=${each.key}\nPORT=${each.value.port}\nENV=${each.value.env}"
}

output "env_configs" {
  description = "Fichiers créés par for_each (set)"
  value       = { for k, v in local_file.env_config : k => v.filename }
}

output "server_configs" {
  description = "Fichiers créés par for_each (map)"
  value       = { for k, v in local_file.server_config : k => v.filename }
}
```

**Explication :**

- **`for_each` sur un set** : `local_file.env_config` crée un fichier par environnement (`dev`, `staging`, `prod`). La clé `each.key` correspond au nom de l'environnement.
- **`for_each` sur une map** : `local_file.server_config` crée un fichier par serveur (`web`, `api`, `db`). `each.key` est le nom du serveur et `each.value` contient ses propriétés (`port`, `env`).
- Les outputs utilisent une **for expression** pour retourner un objet `{ nom => chemin }`.

---

### Commandes Terraform

1. ***`terraform init`*** : *Initialiser* terraform
2. ***`terraform validate`*** : *Valider* le code terraform
3. ***`terraform fmt`*** : *Formater* le code terraform
4. ***`terraform plan`*** : *Réviser* le plan terraform — Terraform affichera 6 resources `local_file` à créer (3 env + 3 serveurs)
5. ***`terraform apply`*** : *Créer* des Resources avec terraform — les fichiers `.conf` seront créés dans `output/`
6. ***`terraform destroy`*** : *Détruire ou supprimer* des Resources, Nettoyer les resources créées

---

### Références

- [Le Meta-Argument for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
