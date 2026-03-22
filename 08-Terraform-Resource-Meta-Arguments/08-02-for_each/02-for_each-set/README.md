> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Meta-Argument Terraform : *`for_each`* — set avec déduplication

### Meta-Argument ***`for_each`*** + ***`toset()`***

- La fonction ***`toset()`*** convertit une liste en set, **supprimant automatiquement les doublons**.
- Avec `for_each = toset(...)`, Terraform crée **une resource distincte par valeur unique**.
- Dans un set, **`each.key` et `each.value` sont identiques** — ils correspondent tous les deux à l'élément du set.
- C'est particulièrement utile pour créer des resources nommées (utilisateurs, profils, environnements) à partir d'une liste où des doublons pourraient exister par erreur.

---

### Exemple

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
  region = "us-east-1"

  default_tags {
    tags = {
      Terraform = "yes"
      Project   = "terraform-learning"
    }
  }

}
```

> **Note** : Ce sous-module utilise encore l'ancien `00_provider.tf` avec AWS. Le fichier `.tf` principal (`01_iam.tf`) utilise lui le provider `local` — aucune credential AWS n'est effectivement nécessaire pour exécuter ce lab.

[01_iam.tf](./01_iam.tf)

```hcl
# Meta-argument FOR_EACH — set
# Crée un fichier de profil par utilisateur
# Équivaut à créer des utilisateurs IAM avec for_each + toset()
# Note : les doublons dans un set sont automatiquement dédupliqués

resource "local_file" "user_profile" {
  for_each = toset(["Amar", "Akbar", "Anthony", "Amar"]) # "Amar" dédupliqué par le set

  filename = "${path.module}/output/${each.key}-profile.conf"
  content  = <<-EOT
    USERNAME=${each.key}
    ROLE=developer
    CREATED=true
  EOT
}

output "user_profiles" {
  description = "Profils utilisateurs créés (doublons supprimés par le set)"
  value       = { for k, v in local_file.user_profile : k => v.filename }
}
```

**Explication :**

- La liste `["Amar", "Akbar", "Anthony", "Amar"]` contient `"Amar"` deux fois.
- `toset()` supprime le doublon — Terraform ne crée donc que **3 fichiers** (`Amar-profile.conf`, `Akbar-profile.conf`, `Anthony-profile.conf`).
- `each.key` est utilisé à la fois comme nom de fichier et comme contenu du champ `USERNAME`.
- L'output retourne un objet `{ nom => chemin_fichier }` grâce à une for expression.

---

### Commandes Terraform

1. ***`terraform init`*** : *Initialiser* terraform
2. ***`terraform validate`*** : *Valider* le code terraform
3. ***`terraform fmt`*** : *Formater* le code terraform
4. ***`terraform plan`*** : *Réviser* le plan terraform — Terraform affichera 3 resources à créer (et non 4, grâce à la déduplication)
5. ***`terraform apply`*** : *Créer* des Resources avec terraform — 3 fichiers `.conf` créés dans `output/`
6. ***`terraform destroy`*** : *Détruire ou supprimer* des Resources, Nettoyer les resources créées

---

### Références

- [Le Meta-Argument for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
- [Fonction toset()](https://developer.hashicorp.com/terraform/language/functions/toset)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
