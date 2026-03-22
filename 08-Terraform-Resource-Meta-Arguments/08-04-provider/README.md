> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Meta-Argument Terraform : *`provider`*

### Meta-Argument ***`provider`***

- *`provider`* vous permet d'utiliser **plusieurs instances d'un même provider** dans Terraform grâce aux **alias**.
- Vous pouvez ainsi **gérer des resources dans différentes régions ou environnements** au sein d'une même configuration.
- Chaque définition de provider avec un `alias` spécifie un ensemble différent de paramètres de configuration.
- Pour cibler un provider aliasé depuis une resource, on utilise le meta-argument `provider = <type>.<alias>`.

**Scénario** : Ce lab simule le déploiement d'infrastructure dans **deux régions distinctes** (Europe et Asie) en utilisant deux providers `local` aliasés. En production, on remplacerait `local` par `aws` avec des régions différentes.

---

### Exemple

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_version = "~> 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Meta-argument PROVIDER — deux providers aliasés
# Simule deux régions AWS (eu-west-1 et ap-south-1)

provider "local" {
  alias = "project-europe"
}

provider "local" {
  alias = "project-asia"
}
```

[01_vpc.tf](./01_vpc.tf)

```hcl
# Meta-argument PROVIDER
# Chaque ressource cible explicitement un provider aliasé
# Simule : créer des VPCs dans deux régions AWS différentes

resource "local_file" "europe_config" {
  provider = local.project-europe
  filename = "${path.module}/output/europe/infra.conf"
  content  = "REGION=eu-west-1\nENV=europe\nVPC_CIDR=10.1.0.0/16"
}

resource "local_file" "asia_config" {
  provider = local.project-asia
  filename = "${path.module}/output/asia/infra.conf"
  content  = "REGION=ap-south-1\nENV=asia\nVPC_CIDR=10.2.0.0/16"
}

output "europe_config_path" {
  value = local_file.europe_config.filename
}

output "asia_config_path" {
  value = local_file.asia_config.filename
}
```

**Explication :**

- Deux blocs `provider "local"` sont définis, chacun avec un `alias` distinct : `project-europe` et `project-asia`.
- `local_file.europe_config` cible explicitement `provider = local.project-europe`.
- `local_file.asia_config` cible explicitement `provider = local.project-asia`.
- Cette approche est directement transposable à un vrai déploiement multi-région AWS : il suffit de remplacer `local` par `aws` et d'ajouter l'attribut `region` dans chaque bloc provider.

---

### Commandes Terraform

1. ***`terraform init`*** : *Initialiser* terraform
2. ***`terraform validate`*** : *Valider* le code terraform
3. ***`terraform fmt`*** : *Formater* le code terraform
4. ***`terraform plan`*** : *Réviser* le plan terraform — Terraform affichera 2 resources `local_file`, chacune associée à son provider aliasé
5. ***`terraform apply`*** : *Créer* des Resources avec terraform — deux fichiers `infra.conf` seront créés dans `output/europe/` et `output/asia/`
6. ***`terraform destroy`*** : *Détruire ou supprimer* des Resources, Nettoyer les resources créées

---

### Références

- [Le Meta-Argument provider de Resource](https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider)
- [Configuration des alias de providers](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
