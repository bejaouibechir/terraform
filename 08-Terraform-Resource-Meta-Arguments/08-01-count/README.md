> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Meta-Argument Terraform : *`count`*

### Meta-Argument ***`count`***

- Le meta-argument ***count*** vous permet de **spécifier le nombre d'instances d'une resource que vous souhaitez créer**.

- ***count*** est utilisé lorsque vous **avez besoin de plusieurs resources identiques avec la même configuration**.

- ***count*** peut être utilisé avec les **modules** et avec **tous les types de resources**.

- L'argument ***count*** **doit être un nombre entier non négatif**.

- Si ***count*** est **défini à 0**, il **ne créera aucune instance de la resource**.

- Vous pouvez également **utiliser des expressions** pour déterminer le count de manière dynamique.

- Lorsque chaque instance est créée, elle possède son propre objet d'infrastructure distinct, ainsi **chacune peut être gérée séparément**. Lorsque la configuration est appliquée, chaque objet peut être créé, détruit ou mis à jour selon les besoins.

- ***`count.index`***

  - ***count.index*** est une variable spéciale utilisée conjointement avec le meta-argument *count*.
  - ***count.index*** vous permet d'accéder à l'index courant d'une instance de resource dans un bloc count.
  - Cela peut être particulièrement utile lorsque vous avez besoin de configurations de resources uniques ou qui dépendent de leur position dans la liste des instances créées par count.
  - ***count.index*** est un index à base zéro, ce qui signifie qu'il commence à 0.

- **Remarque** : Un **bloc de resource ou de module donné ne peut pas utiliser à la fois ***count***** et ***for_each***.

---

### Exemple

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

[01_ec2.tf](./01_ec2.tf)

```hcl
# Meta-argument COUNT
# Crée 3 fichiers de configuration identiques numérotés
# Équivaut à créer 3 instances EC2 avec count = 3

resource "local_file" "server" {
  count    = 3
  filename = "${path.module}/output/server-${count.index}.conf"
  content  = <<-EOT
    # Serveur ${count.index}
    SERVER_ID=${count.index}
    SERVER_NAME=server-${count.index}
    ENVIRONMENT=dev
  EOT
}

output "server_files" {
  description = "Liste des fichiers créés par count"
  value       = local_file.server[*].filename
}

output "first_server" {
  description = "Premier serveur (index 0)"
  value       = local_file.server[0].filename
}
```

Dans cet exemple, `count = 3` crée trois fichiers distincts : `server-0.conf`, `server-1.conf` et `server-2.conf`. La variable `count.index` est utilisée pour nommer chaque fichier de façon unique. L'output `server_files` utilise la syntaxe splat `[*]` pour retourner la liste de tous les fichiers créés.

---

### Commandes Terraform

1. ***`terraform init`*** : *Initialiser* terraform
2. ***`terraform validate`*** : *Valider* le code terraform
3. ***`terraform fmt`*** : *Formater* le code terraform
4. ***`terraform plan`*** : *Réviser* le plan terraform — Terraform affichera la création de 3 resources `local_file`
5. ***`terraform apply`*** : *Créer* des Resources avec terraform — trois fichiers `.conf` seront créés dans le dossier `output/`
6. ***`terraform destroy`*** : *Détruire ou supprimer* des Resources, Nettoyer les resources créées

---

### Références

- [Le Meta-Argument count](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
