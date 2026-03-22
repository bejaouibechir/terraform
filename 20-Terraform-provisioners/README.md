# Provisioners Terraform

> ✅ Ce lab utilise uniquement des providers légers — aucune credential requise.

- Les provisioners Terraform sont utilisés pour **exécuter des scripts ou des commandes sur une resource locale ou distante** lors de sa création ou de sa destruction.
- Les provisioners permettent d'**effectuer des tâches de configuration supplémentaires** qui ne peuvent pas être réalisées directement via les arguments des resources.
- **Remarque :** HashiCorp recommande d'utiliser les provisioners en **dernier recours**. Privilégiez les outils natifs du provider lorsque c'est possible.

## Types de Provisioners

| Provisioner | Exécution | Usage typique |
|---|---|---|
| *`local-exec`* | Sur la **machine locale** qui exécute Terraform | Appels CLI, enregistrement d'infos localement, scripts |
| *`file`* | Copie de fichiers vers la **resource distante** | Déposer des scripts de configuration |
| *`remote-exec`* | Sur la **resource distante** via SSH/WinRM | Installation de logiciels, configuration initiale |

> Dans ce lab, seul `local-exec` est utilisé — aucune connexion SSH ni serveur distant nécessaire.

---

## Exemple Pratique

**Scénario** : Simuler le provisionnement d'un serveur à l'aide d'une `null_resource` avec 4 provisioners `local-exec` :
1. Provisioner 1 — loguer le démarrage du serveur dans `output/provisioner.log`
2. Provisioner 2 — créer un script `output/setup.sh` (simule la copie d'un script vers un serveur)
3. Provisioner 3 — exécuter le script (simule `remote-exec`)
4. Provisioner 4 — loguer la destruction du serveur (`when = destroy`)

### Structure des Fichiers

```
20-Terraform-provisioners/
├── 00_provider.tf
├── 01_variables.tf
├── 02_security_group.tf
├── 03_ec2.tf
├── 04_outputs.tf
└── output/
    ├── provisioner.log   (créé par les provisioners)
    └── setup.sh          (créé par les provisioners)
```

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "null" {}
provider "random" {}
provider "local" {}
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

variable "app_name" {
  description = "Nom de l'application"
  type        = string
  default     = "myapp"
}
```

[02_security_group.tf](./02_security_group.tf)

```hcl
# Ressource de base pour simuler un serveur
resource "random_pet" "server_name" {
  length = 2
  prefix = var.environment
}

resource "random_id" "server_id" {
  byte_length = 4
}
```

> Note : `02_security_group.tf` contient ici les resources `random_pet` et `random_id` qui simulent les métadonnées du serveur — aucun security group AWS n'est nécessaire.

[03_ec2.tf](./03_ec2.tf)

```hcl
resource "null_resource" "server_provisioner" {
  triggers = {
    server_id = random_id.server_id.hex
  }

  # -------------------------------------------------------
  # Provisioner 1 : local-exec (création)
  # Exécuté localement au moment du terraform apply
  # -------------------------------------------------------
  provisioner "local-exec" {
    command = "echo '[PROVISIONER] Serveur ${random_pet.server_name.id} (${random_id.server_id.hex}) démarré le $(date)' >> ${path.module}/output/provisioner.log"
  }

  # -------------------------------------------------------
  # Provisioner 2 : local-exec (création d'un fichier config)
  # Simule la copie d'un fichier vers un serveur distant
  # -------------------------------------------------------
  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/output
      cat > ${path.module}/output/setup.sh << 'SCRIPT'
#!/bin/bash
echo "Configuration de ${var.app_name} sur ${random_pet.server_name.id}"
echo "Environnement : ${var.environment}"
echo "Propriétaire  : ${var.owner}"
SCRIPT
      chmod +x ${path.module}/output/setup.sh
      echo '[PROVISIONER] Script setup.sh copié avec succès' >> ${path.module}/output/provisioner.log
    EOT
  }

  # -------------------------------------------------------
  # Provisioner 3 : local-exec (exécution du script)
  # Simule remote-exec (dans ce lab, exécution locale)
  # -------------------------------------------------------
  provisioner "local-exec" {
    command = <<-EOT
      bash ${path.module}/output/setup.sh >> ${path.module}/output/provisioner.log 2>&1
      echo '[PROVISIONER] Script exécuté avec succès' >> ${path.module}/output/provisioner.log
    EOT
  }

  # -------------------------------------------------------
  # Provisioner 4 : local-exec when=destroy
  # Exécuté au moment du terraform destroy
  # -------------------------------------------------------
  provisioner "local-exec" {
    when    = destroy
    command = "echo '[DESTROY] Serveur supprimé le $(date)' >> ${path.module}/output/provisioner.log"
  }

  depends_on = [random_pet.server_name, random_id.server_id]
}
```

[04_outputs.tf](./04_outputs.tf)

```hcl
output "server_name" {
  description = "Nom du serveur provisionné"
  value       = random_pet.server_name.id
}

output "server_id" {
  description = "ID unique du serveur"
  value       = random_id.server_id.hex
}

output "provisioner_log" {
  description = "Chemin du journal des provisioners"
  value       = "${path.module}/output/provisioner.log"
}
```

---

## Exécution Pas à Pas

1. ***`terraform init`*** : *Initialiser* Terraform
2. ***`terraform validate`*** : *Valider* le code Terraform
3. ***`terraform fmt`*** : *Formater* le code Terraform
4. ***`terraform plan`*** : *Réviser* le plan Terraform
5. ***`terraform apply`*** : *Créer* les Resources et déclencher les provisioners

<details>
<summary><i>terraform apply</i></summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_id.server_id will be created
  + resource "random_id" "server_id" {
      + byte_length = 4
      + hex         = (known after apply)
    }

  # random_pet.server_name will be created
  + resource "random_pet" "server_name" {
      + id     = (known after apply)
      + length = 2
      + prefix = "dev"
    }

  # null_resource.server_provisioner will be created
  + resource "null_resource" "server_provisioner" {
      + id       = (known after apply)
      + triggers = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

random_id.server_id: Creating...
random_id.server_id: Creation complete after 0s [id=e2a1f83c]
random_pet.server_name: Creating...
random_pet.server_name: Creation complete after 0s [id=dev-gentle-owl]
null_resource.server_provisioner: Creating...
null_resource.server_provisioner: Provisioning with 'local-exec'...
null_resource.server_provisioner (local-exec): Executing: ["/bin/sh" "-c" "echo '[PROVISIONER] Serveur dev-gentle-owl (e2a1f83c) démarré le Sat Mar 21 10:15:00 UTC 2026' >> ./output/provisioner.log"]
null_resource.server_provisioner: Provisioning with 'local-exec'...
null_resource.server_provisioner (local-exec): Executing: ["/bin/sh" "-c" "mkdir -p ./output\ncat > ./output/setup.sh << 'SCRIPT'\n#!/bin/bash\necho \"Configuration de myapp sur dev-gentle-owl\"\necho \"Environnement : dev\"\necho \"Propriétaire  : Venkatesh\"\nSCRIPT\nchmod +x ./output/setup.sh\necho '[PROVISIONER] Script setup.sh copié avec succès' >> ./output/provisioner.log\n"]
null_resource.server_provisioner: Provisioning with 'local-exec'...
null_resource.server_provisioner (local-exec): Executing: ["/bin/sh" "-c" "bash ./output/setup.sh >> ./output/provisioner.log 2>&1\necho '[PROVISIONER] Script exécuté avec succès' >> ./output/provisioner.log\n"]
null_resource.server_provisioner: Creation complete after 0s [id=1234567890]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

provisioner_log = "./output/provisioner.log"
server_id       = "e2a1f83c"
server_name     = "dev-gentle-owl"
```

</details>

### Contenu de `output/provisioner.log` après l'apply

```
[PROVISIONER] Serveur dev-gentle-owl (e2a1f83c) démarré le Sat Mar 21 10:15:00 UTC 2026
[PROVISIONER] Script setup.sh copié avec succès
Configuration de myapp sur dev-gentle-owl
Environnement : dev
Propriétaire  : Venkatesh
[PROVISIONER] Script exécuté avec succès
```

### Contenu de `output/setup.sh` créé par le provisioner

```bash
#!/bin/bash
echo "Configuration de myapp sur dev-gentle-owl"
echo "Environnement : dev"
echo "Propriétaire  : Venkatesh"
```

---

## Comportement des Provisioners en cas d'Échec

- Par défaut, si un provisioner échoue, Terraform **marque la resource comme `tainted`** (altérée).
- Lors du prochain `terraform apply`, la resource `tainted` sera **détruite et recréée**.
- Vous pouvez modifier ce comportement avec l'argument `on_failure` :

```hcl
provisioner "local-exec" {
  on_failure = continue  # ignore l'échec et continue
  # ou
  on_failure = fail      # comportement par défaut : échoue et marque comme tainted

  command = "echo 'test'"
}
```

---

## Provisioners de Destruction (*`when = destroy`*)

- Les provisioners avec `when = destroy` sont exécutés **avant** que la resource soit détruite.
- Utile pour des tâches de nettoyage, archivage de logs, désabonnement de services, etc.

```hcl
provisioner "local-exec" {
  when    = destroy
  command = "echo '[DESTROY] Serveur supprimé le $(date)' >> ${path.module}/output/provisioner.log"
}
```

<details>
<summary><i>terraform destroy (provisioner when=destroy)</i></summary>

```shell
$ terraform destroy -auto-approve

null_resource.server_provisioner: Destroying... [id=1234567890]
null_resource.server_provisioner: Provisioning with 'local-exec'...
null_resource.server_provisioner (local-exec): Executing: ["/bin/sh" "-c" "echo '[DESTROY] Serveur supprimé le Sat Mar 21 10:30:00 UTC 2026' >> ./output/provisioner.log"]
null_resource.server_provisioner: Destruction complete after 0s
random_pet.server_name: Destroying...
random_pet.server_name: Destruction complete after 0s
random_id.server_id: Destroying...
random_id.server_id: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.
```

</details>

### Contenu de `output/provisioner.log` après le destroy

```
[PROVISIONER] Serveur dev-gentle-owl (e2a1f83c) démarré le Sat Mar 21 10:15:00 UTC 2026
[PROVISIONER] Script setup.sh copié avec succès
Configuration de myapp sur dev-gentle-owl
Environnement : dev
Propriétaire  : Venkatesh
[PROVISIONER] Script exécuté avec succès
[DESTROY] Serveur supprimé le Sat Mar 21 10:30:00 UTC 2026
```

---

## Références :

- [Provisioners Terraform](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
- [local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)
- [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)
- [Provider random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
