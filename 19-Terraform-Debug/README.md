# Terraform Debug

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
| **`TRACE`** | Journalisation la plus détaillée — requêtes/réponses API complètes, opérations internes |
| **`DEBUG`** | Informations détaillées sur les actions et décisions de Terraform                       |
| **`INFO`**  | Informations de haut niveau sur ce que fait Terraform                                   |
| **`WARN`**  | Messages d'avertissement — problèmes potentiels ou erreurs non fatales                  |
| **`ERROR`** | Messages d'erreur uniquement — problèmes critiques empêchant l'exécution                |

---

## Exemple Pratique

Utilisons un VPC simple pour observer la journalisation Terraform à différents niveaux.

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

[02_vpc.tf](./02_vpc.tf)

```hcl
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC-Debug"
  }
}
```

[03_outputs.tf](./03_outputs.tf)

```hcl
output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.myvpc.id
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
<summary> <i>terraform init (avec TRACE)</i> </summary>

```shell
$ terraform init
2024-01-15T10:23:01.456+0100 [INFO]  Terraform version: 1.6.6
2024-01-15T10:23:01.456+0100 [INFO]  Go runtime version: go1.21.5
2024-01-15T10:23:01.457+0100 [INFO]  CLI args: []string{"terraform", "init"}
2024-01-15T10:23:01.458+0100 [TRACE] Stdout is a terminal of width 220
2024-01-15T10:23:01.458+0100 [TRACE] Stderr is a terminal of width 220
2024-01-15T10:23:01.458+0100 [TRACE] Stdin is a terminal
2024-01-15T10:23:01.459+0100 [DEBUG] Attempting to open CLI config file: /home/user/.terraformrc
2024-01-15T10:23:01.460+0100 [DEBUG] No config file found; using default settings
2024-01-15T10:23:01.461+0100 [TRACE] Finding hashicorp/aws versions matching "~> 5.0"...
2024-01-15T10:23:02.105+0100 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions
2024-01-15T10:23:02.890+0100 [TRACE] HTTP response received: status=200
2024-01-15T10:23:02.891+0100 [INFO]  Installing hashicorp/aws v5.31.0...

Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.31.0...
- Installed hashicorp/aws v5.31.0 (signed by HashiCorp)

Terraform has been successfully initialized!
```

</details>

<details>
<summary> <i>terraform apply -auto-approve (avec TRACE)</i> </summary>

```shell
$ terraform apply -auto-approve
2024-01-15T10:24:15.123+0100 [INFO]  CLI args: []string{"terraform", "apply", "-auto-approve"}
2024-01-15T10:24:15.124+0100 [TRACE] Acquiring state lock
2024-01-15T10:24:15.200+0100 [DEBUG] Building AWS client config for region: us-east-1
2024-01-15T10:24:15.850+0100 [TRACE] POST https://ec2.us-east-1.amazonaws.com/
2024-01-15T10:24:15.851+0100 [TRACE] Request body: Action=CreateVpc&CidrBlock=10.0.0.0%2F16&...
2024-01-15T10:24:18.320+0100 [TRACE] HTTP response received: status=200
2024-01-15T10:24:18.321+0100 [DEBUG] aws_vpc.myvpc: Creation complete [id=vpc-0ab12cd34ef567890]
2024-01-15T10:24:18.322+0100 [TRACE] Releasing state lock

aws_vpc.myvpc: Creating...
aws_vpc.myvpc: Creation complete after 3s [id=vpc-0ab12cd34ef567890]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:
vpc_id = "vpc-0ab12cd34ef567890"
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

# Rechercher les appels API AWS
grep "POST\|GET\|PUT\|DELETE" terraform-trace.log
```

<details>
<summary> <i>Exemple de contenu terraform-trace.log</i> </summary>

```shell
2024-01-15T10:24:15.123+0100 [INFO]  Terraform version: 1.6.6
2024-01-15T10:24:15.124+0100 [TRACE] Acquiring state lock
2024-01-15T10:24:15.200+0100 [DEBUG] Building AWS client config for region: us-east-1
2024-01-15T10:24:15.201+0100 [TRACE] AWS credentials found via environment variables
2024-01-15T10:24:15.850+0100 [TRACE] POST https://ec2.us-east-1.amazonaws.com/
2024-01-15T10:24:15.851+0100 [TRACE] Request body: Action=CreateVpc&CidrBlock=10.0.0.0%2F16
2024-01-15T10:24:18.320+0100 [TRACE] HTTP response received: status=200
2024-01-15T10:24:18.321+0100 [DEBUG] aws_vpc.myvpc: applying "create" change
2024-01-15T10:24:18.322+0100 [INFO]  aws_vpc.myvpc: Creation complete [id=vpc-0ab12cd34ef567890]
2024-01-15T10:24:18.323+0100 [TRACE] Releasing state lock
```

</details>

---

### Étape 4 — Changer le Niveau de Journalisation

Vous pouvez ajuster le niveau selon votre besoin. Pour un diagnostic moins verbeux :

```shell
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

https://developer.hashicorp.com/terraform/internals/debugging
