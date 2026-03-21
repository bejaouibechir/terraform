# Étude de Cas 1 — Provider `local`

## Objectif

Apprendre à utiliser le provider `hashicorp/local` pour **générer des fichiers locaux** avec Terraform, sans avoir besoin d'un compte cloud.
C'est un excellent point de départ pour comprendre le cycle de vie Terraform (init → plan → apply → destroy) dans un environnement 100% local.

## Concepts Abordés

- Provider `hashicorp/local`
- Resource `local_file` et `local_sensitive_file`
- Fonction `templatefile()` pour générer du contenu dynamique
- Data source `local_file` pour lire un fichier existant
- Outputs Terraform

## Architecture

```
01-local-provider/
├── 00_provider.tf         # Provider local
├── 01_variables.tf        # Variables (environnement, auteur)
├── 02_files.tf            # Resources local_file
├── 03_outputs.tf          # Outputs (chemins des fichiers créés)
└── output/                # Répertoire créé par Terraform (gitignore)
```

## Fichiers Générés

Après `terraform apply`, les fichiers suivants sont créés dans `./output/` :

| Fichier | Contenu |
|---------|---------|
| `hello.txt` | Message de bienvenue en texte brut |
| `config.json` | Configuration JSON avec l'environnement et la date |
| `inventory.ini` | Fichier d'inventaire Ansible (exemple d'intégration) |

## Étapes du Lab

### 1. Initialisation

```bash
terraform init
```

### 2. Planification

```bash
terraform plan
```

### 3. Application

```bash
terraform apply -auto-approve
```

**Output attendu :**

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

hello_file_path    = "./output/hello.txt"
config_file_path   = "./output/config.json"
inventory_file_path = "./output/inventory.ini"
```

### 4. Vérification

```bash
cat output/hello.txt
cat output/config.json
cat output/inventory.ini
```

### 5. Nettoyage

```bash
terraform destroy -auto-approve
```

> Les fichiers dans `./output/` sont supprimés par Terraform.

## Références

- https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
- https://developer.hashicorp.com/terraform/language/functions/templatefile
