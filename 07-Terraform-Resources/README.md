# Resource Terraform

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

- Une **Resource Terraform** est une unité fondamentale utilisée pour modéliser et gérer des composants d'infrastructure.

- Chaque resource block décrit un ou plusieurs ***objets d'infrastructure*** que vous souhaitez créer, modifier ou gérer.

  - Exemple : ***local_file***, ***random_id***, ***random_password***, ***tls_private_key***

- [**Syntaxe d'une resource**](https://developer.hashicorp.com/terraform/language/resources/syntax)

  ```hcl
  resource "type" "nom" {
      argument1 = "valeur1"
      argument2 = "valeur2"
      ......... = "......"
      argumentn = "valeurn"
  }
  ```

- **Exemple d'un Resource Block :**

  ```hcl
  resource "random_id" "app_id" {
    byte_length = 6
  }
  ```

  - **`resource` :** Le mot-clé pour démarrer un bloc ***resource***.
  - **`random_id` :**
    - Le **type de resource**, qui définit ce que vous créez (ici un identifiant aléatoire).
    - Le type de resource détermine le type d'objet qu'il gère, ainsi que les arguments et attributs supportés.
  - **`app_id`** :
    - Le **nom de la resource**, identifiant unique dans votre configuration.
    - C'est un nom local utilisé pour référencer cette resource ailleurs dans le module Terraform.
  - **`byte_length`** : Argument de configuration spécifique à la resource.

## Comportements des Resources Terraform

Les comportements des resources Terraform concernent :

- La façon dont Terraform gère et interagit avec les resources de votre infrastructure.

- Ces comportements déterminent comment les resources sont
  - ***créées***
  - ***détruites***
  - ***mises à jour***

1. ***Créer*** :
   - Terraform **crée des resources** qui existent dans la configuration mais ne sont pas encore associées à un objet réel dans le state.

2. ***Détruire*** :
   - ***Détruit* des resources** qui existent dans le state mais n'existent plus dans la configuration.

3. ***Mise à jour en place*** :
   - ***Met à jour* les resources** dont les arguments ont changé sans les recréer.

4. ***Destruction et recréation*** :
   - Terraform ***détruit et recrée* les resources** dont les arguments ont changé mais qui ne peuvent pas être mis à jour en place.

5. ***Gestion des Dépendances*** :
   - Terraform s'assure que les resources dépendantes sont créées avant les resources qui en dépendent.

6. ***Contrôle de la Concurrence*** :
   - Terraform gère la concurrence des opérations pour prévenir les conflits et garantir la cohérence.

7. ***Gestion du State*** :
   - Terraform maintient un state file qui enregistre l'état courant de l'infrastructure.

## Dépendances entre Resources

Terraform gère deux types de dépendances entre resources :

### Dépendance Implicite

Terraform détecte **automatiquement** une dépendance lorsqu'une resource référence un attribut d'une autre resource. Dans l'exemple ci-dessous, `local_file.app_config` référence `random_id.app_id.hex` et `random_password.db_password.result` — Terraform créera donc `random_id` et `random_password` **avant** `local_file`.

### Dépendance Explicite via `depends_on`

Lorsque Terraform ne peut pas détecter automatiquement une dépendance (par exemple, un fichier qui doit exister avant un autre sans référence directe), on utilise `depends_on` pour la déclarer explicitement.

## Exemple Pratique

### Structure des Fichiers

```
07-Terraform-Resources/
├── 00_provider.tf
├── 01_resources.tf
├── 02_outputs.tf
└── output/
    ├── app.json       (créé par Terraform)
    └── README.txt     (créé par Terraform)
```

[00_provider.tf](./00_provider.tf)

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

[01_resources.tf](./01_resources.tf)

```hcl
# -------------------------------------------------------
# Dépendance IMPLICITE
# random_id est créé en premier car local_file le référence
# Terraform détecte cette dépendance automatiquement
# -------------------------------------------------------
resource "random_id" "app_id" {
  byte_length = 6
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%"
}

# Ce fichier dépend implicitement de random_id.app_id et random_password.db_password
resource "local_file" "app_config" {
  filename = "${path.module}/output/app.json"
  content = jsonencode({
    app_id      = random_id.app_id.hex
    environment = "production"
    database = {
      host     = "db.example.com"
      port     = 5432
      password = random_password.db_password.result
    }
  })
}

# -------------------------------------------------------
# Dépendance EXPLICITE via depends_on
# Ce fichier ne sera créé qu'après app_config
# -------------------------------------------------------
resource "local_file" "app_readme" {
  filename = "${path.module}/output/README.txt"
  content  = "Application ${random_id.app_id.hex} déployée par Terraform."

  depends_on = [local_file.app_config]
}
```

[02_outputs.tf](./02_outputs.tf)

```hcl
output "app_id" {
  description = "ID unique de l'application"
  value       = random_id.app_id.hex
}

output "db_password" {
  description = "Mot de passe base de données (sensible)"
  value       = random_password.db_password.result
  sensitive   = true
}

output "config_path" {
  description = "Chemin du fichier de configuration"
  value       = local_file.app_config.filename
}
```

## Exécution Pas à Pas

1. ***`terraform init`*** : *Initialiser* Terraform — télécharge les providers `local` et `random`
2. ***`terraform validate`*** : *Valider* la configuration
3. ***`terraform fmt`*** : *Formater* le code
4. ***`terraform plan`*** : *Réviser* le plan d'exécution
5. ***`terraform apply`*** : *Créer* les resources

<details>
<summary><i>terraform apply</i></summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_id.app_id will be created
  + resource "random_id" "app_id" {
      + byte_length = 6
      + hex         = (known after apply)
      + id          = (known after apply)
    }

  # random_password.db_password will be created
  + resource "random_password" "db_password" {
      + length           = 16
      + result           = (sensitive value)
      + special          = true
      + override_special = "!#$%"
    }

  # local_file.app_config will be created
  + resource "local_file" "app_config" {
      + filename = "./output/app.json"
    }

  # local_file.app_readme will be created
  + resource "local_file" "app_readme" {
      + filename = "./output/README.txt"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

random_id.app_id: Creating...
random_id.app_id: Creation complete after 0s [id=a3f8c21d4e7b]
random_password.db_password: Creating...
random_password.db_password: Creation complete after 0s [id=none]
local_file.app_config: Creating...
local_file.app_config: Creation complete after 0s [id=...]
local_file.app_readme: Creating...
local_file.app_readme: Creation complete after 0s [id=...]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

app_id      = "a3f8c21d4e7b"
config_path = "./output/app.json"
db_password = <sensitive>
```

</details>

Notez l'ordre de création :
1. `random_id.app_id` et `random_password.db_password` (aucune dépendance)
2. `local_file.app_config` (dépend implicitement des deux ci-dessus)
3. `local_file.app_readme` (dépend explicitement de `app_config` via `depends_on`)

### Contenu du fichier `output/app.json` généré

```json
{
  "app_id": "a3f8c21d4e7b",
  "database": {
    "host": "db.example.com",
    "password": "Xk3!mP9#nQ2$vR8%",
    "port": 5432
  },
  "environment": "production"
}
```

### Nettoyage

```shell
terraform destroy -auto-approve
```

## Références :

- [Syntaxe des Resources](https://developer.hashicorp.com/terraform/language/resources/syntax)
- [Comportement des Resources](https://developer.hashicorp.com/terraform/language/resources/behavior)
- [depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
