# Terraform Debug

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Bases du Debug Terraform

- Le Debug Terraform est une fonctionnalité qui vous permet de **dépanner et diagnostiquer les problèmes avec vos configurations et votre state Terraform**.
- Terraform expose deux **variables d'environnement** pour contrôler la journalisation :

| Variable          | Rôle                                 |
| ----------------- | ------------------------------------ |
| **`TF_LOG`**      | Spécifie le niveau de journalisation |
| **`TF_LOG_PATH`** | Spécifie le chemin du fichier de log |

## Niveaux de Journalisation *`TF_LOG`*

Les niveaux sont ordonnés du plus détaillé au moins détaillé :

| Niveau      | Description                                                                             |
| ----------- | --------------------------------------------------------------------------------------- |
| **`TRACE`** | Journalisation la plus détaillée — communications provider complètes, opérations internes |
| **`DEBUG`** | Informations détaillées sur les actions et décisions de Terraform                       |
| **`INFO`**  | Informations de haut niveau sur ce que fait Terraform                                   |
| **`WARN`**  | Messages d'avertissement — problèmes potentiels ou erreurs non fatales                  |
| **`ERROR`** | Messages d'erreur uniquement — problèmes critiques empêchant l'exécution                |

---

## Exemple Pratique

Ce module utilise les providers `random` et `local` pour créer un nom aléatoire et un fichier de debug — sans aucune credential requise.

### Structure des Fichiers

```
19-Terraform-Debug/
├── 00_provider.tf
├── 01_variables.tf
├── 02_vpc.tf
├── 03_outputs.tf
└── output/
    └── debug.txt    (créé par Terraform)
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

[01_variables.tf](./01_variables.tf)

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

[02_vpc.tf](./02_vpc.tf)

```hcl
resource "random_pet" "resource_name" {
  length = 2
  prefix = var.environment
}

resource "random_id" "resource_id" {
  byte_length = 4
}

resource "local_file" "debug_output" {
  filename = "${path.module}/output/debug.txt"
  content  = "RESOURCE=${random_pet.resource_name.id}\nID=${random_id.resource_id.hex}\nOWNER=${var.owner}"
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
output "resource_name" {
  description = "Nom de la ressource créée"
  value       = random_pet.resource_name.id
}

output "resource_id" {
  description = "ID unique de la ressource"
  value       = random_id.resource_id.hex
}
```

---

## Exécution Pas à Pas

### Étape 1 — Activer la Journalisation TRACE

Définissez les variables d'environnement **avant** d'exécuter toute commande Terraform :

#### Linux / MAC OS

```shell
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"

# Vérifier
echo $TF_LOG
echo $TF_LOG_PATH
```

#### Windows Powershell

```powershell
$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="terraform-trace.log"

# Vérifier
echo $env:TF_LOG
echo $env:TF_LOG_PATH
```

---

### Étape 2 — Exécuter les Commandes Terraform

Toutes les commandes ci-dessous génèrent des logs dans le fichier `terraform-trace.log` :

```shell
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

<details>
<summary><i>terraform init (avec TRACE)</i></summary>

```shell
$ terraform init
2024-01-15T10:23:01.456+0100 [INFO]  Terraform version: 1.6.6
2024-01-15T10:23:01.456+0100 [INFO]  Go runtime version: go1.21.5
2024-01-15T10:23:01.457+0100 [INFO]  CLI args: []string{"terraform", "init"}
2024-01-15T10:23:01.458+0100 [TRACE] Stdout is a terminal of width 220
2024-01-15T10:23:01.458+0100 [TRACE] Stderr is a terminal of width 220
2024-01-15T10:23:01.459+0100 [DEBUG] Attempting to open CLI config file: /home/user/.terraformrc
2024-01-15T10:23:01.460+0100 [DEBUG] No config file found; using default settings
2024-01-15T10:23:01.461+0100 [TRACE] Finding hashicorp/random versions matching "~> 3.0"...
2024-01-15T10:23:02.105+0100 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/random/versions
2024-01-15T10:23:02.890+0100 [TRACE] HTTP response received: status=200
2024-01-15T10:23:02.891+0100 [INFO]  Installing hashicorp/random v3.6.0...
2024-01-15T10:23:03.200+0100 [INFO]  Installing hashicorp/local v2.4.0...

Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/random versions matching "~> 3.0"...
- Finding hashicorp/local versions matching "~> 2.0"...
- Installing hashicorp/random v3.6.0...
- Installing hashicorp/local v2.4.0...

Terraform has been successfully initialized!
```

</details>

<details>
<summary><i>terraform apply -auto-approve (avec TRACE)</i></summary>

```shell
$ terraform apply -auto-approve
2024-01-15T10:24:15.123+0100 [INFO]  CLI args: []string{"terraform", "apply", "-auto-approve"}
2024-01-15T10:24:15.124+0100 [TRACE] Acquiring state lock
2024-01-15T10:24:15.200+0100 [DEBUG] provider.terraform-provider-random: configuring provider
2024-01-15T10:24:15.201+0100 [DEBUG] provider.terraform-provider-local: configuring provider
2024-01-15T10:24:15.300+0100 [TRACE] random_pet.resource_name: applying "create" change
2024-01-15T10:24:15.301+0100 [DEBUG] random_pet.resource_name: Creation complete [id=dev-swift-fox]
2024-01-15T10:24:15.302+0100 [TRACE] random_id.resource_id: applying "create" change
2024-01-15T10:24:15.303+0100 [DEBUG] random_id.resource_id: Creation complete [id=a4f1c83e]
2024-01-15T10:24:15.400+0100 [TRACE] local_file.debug_output: applying "create" change
2024-01-15T10:24:15.401+0100 [DEBUG] local_file.debug_output: Creation complete
2024-01-15T10:24:15.402+0100 [TRACE] Releasing state lock

random_pet.resource_name: Creating...
random_pet.resource_name: Creation complete after 0s [id=dev-swift-fox]
random_id.resource_id: Creating...
random_id.resource_id: Creation complete after 0s [id=a4f1c83e]
local_file.debug_output: Creating...
local_file.debug_output: Creation complete after 0s [id=...]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

resource_id   = "a4f1c83e"
resource_name = "dev-swift-fox"
```

</details>

---

### Étape 3 — Inspecter le Fichier de Log

Le fichier `terraform-trace.log` contient la journalisation complète de toutes les opérations :

```shell
# Afficher les dernières lignes du fichier de log
tail -50 terraform-trace.log

# Rechercher les erreurs dans les logs
grep "ERROR\|WARN" terraform-trace.log

# Rechercher les opérations de création
grep "Creation complete\|applying" terraform-trace.log
```

<details>
<summary><i>Exemple de contenu terraform-trace.log</i></summary>

```shell
2024-01-15T10:24:15.123+0100 [INFO]  Terraform version: 1.6.6
2024-01-15T10:24:15.124+0100 [TRACE] Acquiring state lock
2024-01-15T10:24:15.200+0100 [DEBUG] provider.terraform-provider-random: configuring provider
2024-01-15T10:24:15.201+0100 [TRACE] random_pet.resource_name: starting apply
2024-01-15T10:24:15.300+0100 [DEBUG] random_pet.resource_name: applying "create" change
2024-01-15T10:24:15.301+0100 [INFO]  random_pet.resource_name: Creation complete [id=dev-swift-fox]
2024-01-15T10:24:15.302+0100 [TRACE] random_id.resource_id: starting apply
2024-01-15T10:24:15.303+0100 [DEBUG] random_id.resource_id: applying "create" change
2024-01-15T10:24:15.304+0100 [INFO]  random_id.resource_id: Creation complete [id=a4f1c83e]
2024-01-15T10:24:15.400+0100 [TRACE] local_file.debug_output: starting apply
2024-01-15T10:24:15.401+0100 [DEBUG] local_file.debug_output: writing file ./output/debug.txt
2024-01-15T10:24:15.402+0100 [INFO]  local_file.debug_output: Creation complete
2024-01-15T10:24:15.403+0100 [TRACE] Releasing state lock
```

</details>

---

### Étape 4 — Changer le Niveau de Journalisation

Vous pouvez ajuster le niveau selon votre besoin. Pour un diagnostic moins verbeux :

```shell
# Niveau DEBUG : informations détaillées sans les communications internes
export TF_LOG=DEBUG
terraform plan

# Niveau INFO : uniquement les informations importantes
export TF_LOG=INFO
terraform plan

# Niveau ERROR : uniquement les erreurs critiques
export TF_LOG=ERROR
terraform apply -auto-approve
```

---

### Étape 5 — Désactiver la Journalisation

Pour désactiver complètement la journalisation :

#### Linux / MAC OS

```shell
unset TF_LOG
unset TF_LOG_PATH
```

#### Windows Powershell

```powershell
Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
```

---

### Étape 6 — Nettoyage

```shell
# Détruire les resources créées
terraform destroy -auto-approve

# Supprimer les fichiers locaux Terraform et les logs
rm -rf .terraform*
rm -rf terraform.tfstate*
rm -f terraform-trace.log
```

---

## Configuration Permanente des Variables d'Environnement

### Linux Bash

```shell
cd $HOME
vi .bashrc

# Ajouter à la fin du fichier :
# Terraform log settings
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"

# Vérifier dans un nouveau terminal
echo $TF_LOG        # TRACE
echo $TF_LOG_PATH   # terraform-trace.log
```

### Windows Powershell

```powershell
# Ouvrir le profil Powershell
notepad $profile

# Ajouter à la fin du fichier :
$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="terraform-trace.log"

# Fermer et rouvrir Powershell, puis vérifier
echo $env:TF_LOG        # TRACE
echo $env:TF_LOG_PATH   # terraform-trace.log
```

### MAC OS

```shell
cd $HOME
vi .bash_profile

# Ajouter à la fin du fichier :
# Terraform log settings
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"

# Vérifier dans un nouveau terminal
echo $TF_LOG        # TRACE
echo $TF_LOG_PATH   # terraform-trace.log
```

---

## Fichier de Crash Terraform

- Si Terraform plante (une "panique" dans le runtime Go), il sauvegarde automatiquement un fichier **`crash.log`** contenant :
  - Les logs de debug de la session
  - Le message de panique
  - La trace d'exécution (backtrace)
- Ce fichier est destiné à être transmis aux développeurs Terraform via une **Issue GitHub**.
- [Comment lire un fichier de crash ?](https://www.terraform.io/docs/internals/debugging.html#interpreting-a-crash-log)

```shell
# Exemple de début de crash.log
panic: runtime error: invalid memory address or nil pointer dereference

goroutine 1 [running]:
github.com/hashicorp/terraform/...
    /go/src/github.com/hashicorp/terraform/...
```

---

## Références :

- [Terraform Debugging](https://developer.hashicorp.com/terraform/internals/debugging)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
