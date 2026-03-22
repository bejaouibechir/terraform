> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Meta-Argument Terraform : *`lifecycle`*

### Meta-Argument ***`lifecycle`***

- Le meta-argument `lifecycle` dans Terraform est utilisé pour contrôler des aspects spécifiques de **la façon dont les resources sont gérées durant leur cycle de vie**.

- Le meta-argument `lifecycle` offre un contrôle précis sur **quand et comment Terraform doit créer, mettre à jour ou supprimer des resources**.

- Options du meta-argument `lifecycle` :

  1. ***`create_before_destroy`*** :
     - Lorsqu'il est défini à `true`, cet attribut indique que **Terraform doit créer une nouvelle resource avant de détruire l'ancienne** lorsqu'il doit remplacer la resource.
     - Cela peut aider à minimiser les temps d'arrêt lors des mises à jour.
     - L'option par défaut est *`false`* (Terraform détruit d'abord, puis recrée).

  2. ***`ignore_changes`*** :
     - Cet attribut vous permet de spécifier une liste d'attributs pour lesquels Terraform doit ignorer les changements.
     - C'est utile pour empêcher certains attributs d'être écrasés lors des plans et apply suivants.
     - Couramment utilisé lorsque certains attributs peuvent être modifiés hors de Terraform et que vous souhaitez que Terraform respecte cet état.
     - L'option `ignore_changes = all` ignore tous les attributs de la resource.

  3. ***`prevent_destroy`*** :
     - Lorsqu'il est défini à `true`, cet attribut **empêche la resource d'être détruite ou supprimée**.
     - Cela peut être utile pour protéger des resources critiques contre une suppression accidentelle.
     - L'option par défaut est *`false`*.

---

### Exemple — trois options dans un seul fichier

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

[01_lifecycle.tf](./01_lifecycle.tf)

```hcl
# -------------------------------------------------------
# lifecycle : create_before_destroy
# Terraform crée le nouveau fichier AVANT de supprimer l'ancien
# Utile pour les ressources sans downtime
# -------------------------------------------------------
resource "random_pet" "server_name" {
  length = 2

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------------------------------------
# lifecycle : ignore_changes
# Terraform ignore les modifications sur le champ "content"
# Utile quand une ressource est modifiée hors Terraform
# -------------------------------------------------------
resource "local_file" "managed_config" {
  filename = "${path.module}/output/managed.conf"
  content  = "SERVER=${random_pet.server_name.id}\nVERSION=1.0"

  lifecycle {
    ignore_changes = [content]
  }
}

# -------------------------------------------------------
# lifecycle : prevent_destroy
# Terraform refusera de détruire cette ressource
# Décommentez pour tester : terraform destroy échouera
# -------------------------------------------------------
resource "local_file" "critical_config" {
  filename = "${path.module}/output/critical.conf"
  content  = "CRITICAL=true\nDO_NOT_DELETE=yes"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

output "server_name" {
  value = random_pet.server_name.id
}
```

---

### Explication détaillée

#### 1. `create_before_destroy` — sur `random_pet.server_name`

- Par défaut, si Terraform doit remplacer une resource (ex : `random_pet` avec un nouveau `length`), il **détruit d'abord l'ancienne** puis crée la nouvelle.
- Avec `create_before_destroy = true`, Terraform **crée d'abord la nouvelle resource**, puis supprime l'ancienne.
- Cela garantit la continuité : le nouveau nom est disponible avant que l'ancien ne disparaisse.

#### 2. `ignore_changes` — sur `local_file.managed_config`

- `ignore_changes = [content]` indique à Terraform d'**ignorer toute modification du champ `content`** lors des plans suivants.
- Ainsi, si le fichier `managed.conf` est modifié manuellement après le premier `apply`, Terraform ne tentera pas de le réécrire.
- C'est utile pour les fichiers qui peuvent être mis à jour par d'autres processus hors de Terraform.

#### 3. `prevent_destroy` — sur `local_file.critical_config` (commenté)

- `prevent_destroy = true` empêche Terraform de détruire la resource même avec `terraform destroy`.
- Il est **commenté dans cet exemple** pour permettre le nettoyage complet avec `terraform destroy`. Si vous décommentez ce bloc et relancez `apply`, Terraform retournera une erreur lorsque vous tenterez de détruire cette resource.
- Utile en production pour protéger des bases de données, des fichiers de configuration critiques ou tout état non reproductible.

---

### Commandes Terraform

1. ***`terraform init`*** : *Initialiser* terraform
2. ***`terraform validate`*** : *Valider* le code terraform
3. ***`terraform fmt`*** : *Formater* le code terraform
4. ***`terraform plan`*** : *Réviser* le plan terraform
5. ***`terraform apply`*** : *Créer* des Resources avec terraform — `managed.conf` et `critical.conf` créés dans `output/`
6. ***`terraform destroy`*** : *Détruire ou supprimer* des Resources, Nettoyer les resources créées

> **Test `prevent_destroy`** : Décommentez le bloc `lifecycle { prevent_destroy = true }` dans `local_file.critical_config`, relancez `terraform apply`, puis tentez `terraform destroy`. Terraform retournera une erreur `Error: Instance cannot be destroyed`.

---

### Références

- [Le Meta-Argument lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
