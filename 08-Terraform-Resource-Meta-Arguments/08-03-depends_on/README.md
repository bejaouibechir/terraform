> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

## Meta-Argument Terraform : *`depends_on`*

### Meta-Argument ***`depends_on`***

- Le meta-argument ***depends_on*** dans Terraform est utilisé pour **établir des dépendances ***explicites*** entre des resources**, en spécifiant qu'une resource **dépend de la création ou de la modification réussie d'une autre resource**.

- Lorsque vous définissez *`depends_on`* pour une resource, vous indiquez que **cette resource ne doit être créée ou modifiée qu'après que les resources listées dans *`depends_on`* aient été créées ou modifiées avec succès**.

- Cela est particulièrement utile lorsque vous avez des resources qui nécessitent l'achèvement de certaines tâches avant de pouvoir procéder.

### Dépendance implicite vs dépendance explicite

- **Dépendance implicite** : lorsqu'une resource référence directement un attribut d'une autre resource (ex : `random_pet.server.id` dans le contenu d'un `local_file`), Terraform détecte automatiquement l'ordre de création. Aucun `depends_on` n'est nécessaire.

- **Dépendance explicite** : lorsque la relation entre deux resources n'est pas visible dans les attributs (par exemple, une resource doit être prête avant qu'une autre soit écrite), on utilise `depends_on` pour l'exprimer clairement.

---

### Exemple

Dans ce lab, la chaîne de dépendances est la suivante :

```
random_pet.server  →  local_file.server_config  →  local_file.dns_record
   (implicite)                                        (explicite via depends_on)
```

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_version = "~> 1.0"
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
resource "random_pet" "server" {
  length = 2
  prefix = "web"
}

resource "local_file" "server_config" {
  filename = "${path.module}/output/server.conf"
  content  = "SERVER_NAME=${random_pet.server.id}\nSTATUS=running"
}
```

[02_eip.tf](./02_eip.tf)

```hcl
# Meta-argument DEPENDS_ON
resource "local_file" "dns_record" {
  filename   = "${path.module}/output/dns.conf"
  content    = "DNS_ENTRY=${random_pet.server.id}.example.com\nPOINTS_TO=server"
  depends_on = [local_file.server_config]
}

output "server_name" {
  value = random_pet.server.id
}

output "dns_entry" {
  value = "${random_pet.server.id}.example.com"
}
```

**Explication :**

- `random_pet.server` génère un nom aléatoire (ex : `web-happy-fox`).
- `local_file.server_config` utilise ce nom — Terraform détecte la **dépendance implicite** et crée `random_pet.server` en premier.
- `local_file.dns_record` utilise aussi `random_pet.server.id`, mais dépend **explicitement** de `local_file.server_config` via `depends_on`. Terraform s'assure ainsi que `server.conf` est bien écrit avant de créer `dns.conf`.

---

### Commandes Terraform

1. ***`terraform init`*** : *Initialiser* terraform
2. ***`terraform validate`*** : *Valider* le code terraform
3. ***`terraform fmt`*** : *Formater* le code terraform
4. ***`terraform plan`*** : *Réviser* le plan terraform
5. ***`terraform apply`*** : *Créer* des Resources avec terraform — les fichiers `server.conf` et `dns.conf` seront créés dans `output/`
6. ***`terraform destroy`*** : *Détruire ou supprimer* des Resources, Nettoyer les resources créées

---

### Références

- [Le Meta-Argument depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
- [Provider local](https://registry.terraform.io/providers/hashicorp/local/latest/docs)
