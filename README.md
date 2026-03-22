# Guide Complet Terraform — De Débutant à Certifié

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGNZPnTV1nyxncrXRkCWb7hvAxwbwf7pjEnA&s" title="" alt="" data-align="center">

## À Propos

Ce dépôt est un support de formation **complet et progressif** pour apprendre Terraform (Infrastructure as Code) avec AWS. Chaque module combine :

- **Théorie** — concepts expliqués en français avec exemples HCL
- **Démonstration** — fichiers `.tf` prêts à l'emploi
- **Lab pratique** — scripts d'orchestration `lab-script.sh` (Linux/Mac) et `lab-script.ps1` (Windows)

![](C:\Users\DELL\Desktop\terraform-beginners-guide\imgs\iac-terraform.jpg)

## Prérequis

### Outils de base

| Outil                                                          | Version | Statut               | Installation                                                                                                       |
| -------------------------------------------------------------- | ------- | -------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [Terraform](https://developer.hashicorp.com/terraform/install) | ≥ 1.0   | ✅ Installé (v1.14.7) | `brew install terraform` / [installer](https://developer.hashicorp.com/terraform/install)                          |
| [Git](https://git-scm.com/)                                    | ≥ 2.0   | ✅ Installé           | `brew install git` / `apt install git`                                                                             |
| [Docker](https://docs.docker.com/get-docker/)                  | ≥ 20.0  | ✅ Installé (v28.2.2) | `apt install docker.io` / [Docker Desktop](https://docs.docker.com/get-docker/)                                    |
| [LocalStack](https://localstack.cloud/)                        | ≥ 4.0   | ✅ Installé (v4.14.0) | `pip install localstack`                                                                                           |
| [AWS CLI](https://aws.amazon.com/cli/)                         | ≥ 2.0   | ⚙️ Optionnel         | `brew install awscli` / [installer](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |
| Compte AWS réel                                                | —       | ⚙️ Optionnel         | [Créer un compte](https://aws.amazon.com/free/)                                                                    |

### Outils pour études de cas avancées (module 22)

| Outil                                              | Version | Statut       | Installation                                                                    |
| -------------------------------------------------- | ------- | ------------ | ------------------------------------------------------------------------------- |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | ≥ 1.28  | ⚙️ Optionnel | `brew install kubectl` / [installer](https://kubernetes.io/docs/tasks/tools/)   |
| [minikube](https://minikube.sigs.k8s.io/)          | ≥ 1.30  | ⚙️ Optionnel | `brew install minikube` / [installer](https://minikube.sigs.k8s.io/docs/start/) |
| [Ansible](https://docs.ansible.com/)               | ≥ 2.15  | ⚙️ Optionnel | `pip install ansible` / `apt install ansible`                                   |

> **Note :** Les labs 06 à 20 utilisent **LocalStack** pour simuler AWS localement — aucun compte AWS ni credentials réels ne sont nécessaires pour suivre ce support.

### Démarrer LocalStack

```bash
# Installer LocalStack
pip install localstack awscli-local

# Démarrer avec les services nécessaires (EC2, S3, IAM, STS)
export SERVICES=ec2,s3,iam,sts
localstack start -d

# Vérifier que LocalStack est prêt
curl http://localhost:4566/_localstack/health | jq .services
```

### Configuration du provider Terraform pour LocalStack

```hcl
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}
```

---

## Parcours d'Apprentissage

![](C:\Users\DELL\Desktop\terraform-beginners-guide\imgs\learning-path.jpg)

## Contenu des Modules

### Fondamentaux

| Module                                          | Titre                         | Description                                                                                                           | Lab |
| ----------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------- | --- |
| [00](./00-Terraform-Basics/README.md)           | **Terraform — Guide Visuel**  | Qu'est-ce que Terraform ? IaC, providers, workflow init/plan/apply/destroy. Vue d'ensemble illustrée.                 | —   |
| [01](./01-Terraform-Installation/README.md)     | **Installation de Terraform** | Installation sur Windows, Mac et Linux. Configuration du PATH, vérification de version.                               | —   |
| [03](./03-Terraform-Terminologies/README.md)    | **Terminologies Terraform**   | Glossaire des termes clés : provider, resource, state, module, workspace, backend, data source...                     | —   |
| [04](./04-Terraform-Top-Level-Blocks/README.md) | **Blocs de Niveau Supérieur** | Les 8 blocs HCL fondamentaux : `terraform`, `provider`, `resource`, `variable`, `output`, `locals`, `data`, `module`. | ✅   |
| [05](./05-Terraform-Commands/README.md)         | **Commandes Terraform**       | Référence complète des commandes CLI : `init`, `validate`, `fmt`, `plan`, `apply`, `destroy`, `show`, `state`...      | ✅   |

---

### Infrastructure AWS

| Module                                   | Titre                   | Description                                                                                          | Lab |
| ---------------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------------------- | --- |
| [06](./06-Terraform-VPC-Demo/README.md)  | **Démonstration VPC**   | Premier lab AWS complet : création d'un VPC, subnet, internet gateway et route table avec Terraform. | ✅   |
| [07](./07-Terraform-Resources/README.md) | **Resources Terraform** | Syntaxe des ressources, dépendances implicites/explicites (`depends_on`), cycle de vie complet.      | ✅   |

---

### Variables et Outputs

| Module                                                 | Titre                   | Description                                                                                                              | Lab |
| ------------------------------------------------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------ | --- |
| [08](./08-Terraform-Resource-Meta-Arguments/README.md) | **Meta-Arguments**      | `count`, `for_each`, `depends_on`, `lifecycle` (`create_before_destroy`, `prevent_destroy`, `ignore_changes`).           | ✅   |
| [09](./09-Terraform-Variables/README.md)               | **Variables Terraform** | Types de variables (`string`, `number`, `bool`, `list`, `map`, `object`), `terraform.tfvars`, variables d'environnement. | ✅   |
| [10](./10-Terraform-Outputs/README.md)                 | **Outputs Terraform**   | Déclaration d'outputs, outputs sensibles (`sensitive`), partage de valeurs entre modules.                                | ✅   |
| [11](./11-Terraform-Data-Sources/README.md)            | **Data Sources**        | Interroger l'infrastructure existante : `aws_ami`, `aws_vpc`, `aws_availability_zones`. Différence resource vs data.     | ✅   |

---

### State Management

| Module                                        | Titre                 | Description                                                                                                      | Lab |
| --------------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------- | --- |
| [12](./12-Terraform-State/README.md)          | **Terraform State**   | State local vs distant (S3 + DynamoDB). Configuration du backend, verrouillage de state, `terraform state pull`. | ✅   |
| [13](./13-Terraform-Show/README.md)           | **Terraform Show**    | Inspecter le state et les plans avec `terraform show`. Générer et analyser un fichier de plan binaire.           | ✅   |
| [14](./14-Terraform-Refresh/README.md)        | **Terraform Refresh** | Synchroniser le state avec l'infrastructure réelle. Détecter les changements manuels hors Terraform.             | ✅   |
| [15](./15-Terraform-State-Commands/README.md) | **Commandes State**   | `terraform state list`, `show`, `mv`, `rm`, `pull`, `push`. Gestion avancée du fichier de state.                 | ✅   |

---

### Fonctionnalités Avancées

| Module                                      | Titre                 | Description                                                                                                      | Lab |
| ------------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------- | --- |
| [16](./16-Terraform-Workspaces/README.md)   | **Workspaces**        | Gérer plusieurs environnements (dev/staging/prod) avec un seul code. `terraform.workspace` et `lookup()`.        | ✅   |
| [17](./17-Terraform-Modules/README.md)      | **Modules Terraform** | Créer et consommer des modules réutilisables. Structure `modules/vpc/`, appels avec `source`, inputs et outputs. | ✅   |
| [18](./18-Terraform-Import/README.md)       | **Terraform Import**  | Importer des ressources AWS existantes dans le state Terraform. Workflow en 6 étapes.                            | ✅   |
| [19](./19-Terraform-Debug/README.md)        | **Debug & Logs**      | Niveaux de log `TF_LOG` (TRACE, DEBUG, INFO, WARN, ERROR). Analyse des logs, `TF_LOG_PATH`.                      | ✅   |
| [20](./20-Terraform-provisioners/README.md) | **Provisioners**      | `local-exec`, `file`, `remote-exec`. Provisioners de destruction (`when = destroy`), gestion des erreurs.        | ✅   |

---

### Certification & Cas Pratiques

| Module                                          | Titre                          | Description                                                                                                  | Lab |
| ----------------------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------ | --- |
| [21](./21-Terraform-Exam-Cheat-Sheet/README.md) | **Aide-Mémoire Certification** | Référence complète pour l'examen HashiCorp Terraform Associate : commandes, concepts, workspaces, modules... | —   |
| [22](./22-Terraform-Example-Codes/README.md)    | **Études de Cas Avancés**      | 5 études de cas avec providers non-AWS : `local`, LocalStack, Docker, Kubernetes, Ansible.                   | ✅   |

---

## Études de Cas — Providers Avancés

<div align="center">

|     | Provider                     | Technologie                   | Prérequis       |
| --- | ---------------------------- | ----------------------------- | --------------- |
| 🗂️ | `hashicorp/local`            | Génération de fichiers locaux | Terraform seul  |
| 🖥️ | `hashicorp/aws` + LocalStack | Simulation AWS en local       | Docker          |
| 🐳  | `kreuzwerker/docker`         | Conteneurs Docker             | Docker Desktop  |
| ☸️  | `hashicorp/kubernetes`       | Déploiements Kubernetes       | minikube / kind |
| 🔧  | `hashicorp/aws` + Ansible    | Provisioning combiné          | AWS + Ansible   |

</div>

---

## Structure du Dépôt

![](C:\Users\DELL\Desktop\terraform-beginners-guide\imgs\guide-arborescence.jpg)

---

## Comment Utiliser ce Support

### Démarrage rapide

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-repo/terraform-beginners-guide.git
cd terraform-beginners-guide

# 2. Commencer par les bases
cd 00-Terraform-Basics && cat README.md

# 3. Premier lab pratique
cd 06-Terraform-VPC-Demo
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

### Avec les scripts d'orchestration

Chaque module avec un lab dispose d'un script tout-en-un :

```bash
# Linux / Mac
chmod +x lab-script.sh
./lab-script.sh

# Windows PowerShell
.\lab-script.ps1
```

### Conseil d'apprentissage

> Suivez les modules dans l'ordre numérique. Chaque module s'appuie sur les concepts du précédent. Exécutez systématiquement les labs avant de passer au suivant.

---

## Ressources Officielles

| Ressource               | Lien                                                                     |
| ----------------------- | ------------------------------------------------------------------------ |
| Documentation Terraform | https://developer.hashicorp.com/terraform/docs                           |
| Terraform Registry      | https://registry.terraform.io                                            |
| Certification Associate | https://developer.hashicorp.com/certifications/infrastructure-automation |
| AWS Provider Docs       | https://registry.terraform.io/providers/hashicorp/aws/latest/docs        |
| Terraform Tutorials     | https://developer.hashicorp.com/terraform/tutorials                      |
