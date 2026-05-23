![CI](https://github.com/bejaouibechir/terraform/actions/workflows/terraform-ci.yml/badge.svg)

# Guide Complet Terraform

Ce depot est un support de formation progressif pour apprendre Terraform avec AWS, LocalStack et plusieurs providers avancés. Chaque module combine de la theorie, des exemples HCL, et quand c'est pertinent des scripts de lab pour Linux/Mac et Windows.

## Prerequis

| Outil | Version | Usage |
| ----- | ------- | ----- |
| Terraform | >= 1.5 | Executer, formater, valider et planifier l'infrastructure |
| Git | >= 2.0 | Cloner le depot et travailler avec GitHub |
| Docker | >= 20.0 | Lancer LocalStack et les labs Docker |
| LocalStack | >= 4.0 | Simuler AWS en local pour les labs |
| AWS CLI | >= 2.0 | Optionnel pour interagir avec AWS |
| TFLint | Derniere stable | Linter Terraform et provider AWS |
| Checkov | Derniere stable | Scanner la securite IaC |
| kubectl | >= 1.28 | Labs Kubernetes |
| minikube | >= 1.30 | Labs Kubernetes locaux |
| Ansible | >= 2.15 | Lab de provisioning avance |

> Les labs AWS utilisent majoritairement LocalStack. Aucun credential reel ne doit etre stocke dans le code.

## Demarrer LocalStack

```bash
pip install localstack awscli-local
export SERVICES=ec2,s3,iam,sts
localstack start -d
curl http://localhost:4566/_localstack/health
```

## Modules

| Module | Titre | Description |
| ------ | ----- | ----------- |
| [00](./00-Terraform-Basics/README.md) | Terraform Basics | Introduction a l'IaC, au workflow Terraform et aux providers. |
| [01](./01-Terraform-Installation/README.md) | Terraform Installation | Installation de Terraform sur Windows, macOS et Linux. |
| [02](./02-Terraform-Architecture/README.md) | Terraform Architecture | Vue interne de Terraform Core, providers, state et graph engine. |
| [03](./03-Terraform-Terminologies/README.md) | Terraform Terminologies | Glossaire des concepts cles Terraform. |
| [04](./04-Terraform-Top-Level-Blocks/README.md) | Top-Level Blocks | Les blocs HCL principaux : provider, resource, variable, output, data et module. |
| [05](./05-Terraform-Commands/README.md) | Terraform Commands | Commandes CLI essentielles : init, fmt, validate, plan, apply, destroy et state. |
| [06](./06-Terraform-VPC-Demo/README.md) | VPC Demo | Premier lab AWS/LocalStack autour d'un VPC. |
| [07](./07-Terraform-Resources/README.md) | Terraform Resources | Syntaxe des resources et cycle de vie Terraform. |
| [08](./08-Terraform-Resource-Meta-Arguments/README.md) | Meta-Arguments | count, for_each, depends_on, provider et lifecycle. |
| [09](./09-Terraform-Variables/README.md) | Terraform Variables | Types de variables, tfvars, validation et valeurs sensibles. |
| [10](./10-Terraform-Outputs/README.md) | Terraform Outputs | Outputs, valeurs sensibles et partage de donnees. |
| [11](./11-Terraform-Data-Sources/README.md) | Data Sources | Lire des informations existantes avec les data sources. |
| [12](./12-Terraform-State/README.md) | Terraform State | State local, remote state, backend S3 et verrouillage. |
| [13](./13-Terraform-Show/README.md) | Terraform Show | Inspecter le state et les plans Terraform. |
| [14](./14-Terraform-Refresh/README.md) | Terraform Refresh | Synchroniser le state et detecter le drift. |
| [15](./15-Terraform-State-Commands/README.md) | State Commands | Manipuler le state avec list, show, mv, rm, pull et push. |
| [16](./16-Terraform-Workspaces/README.md) | Workspaces | Gerer plusieurs environnements avec terraform.workspace. |
| [17](./17-Terraform-Modules/README.md) | Terraform Modules | Composer des modules locaux VPC, EC2 et S3. |
| [18](./18-Terraform-Import/README.md) | Terraform Import | Importer une infrastructure existante dans le state. |
| [19](./19-Terraform-Debug/README.md) | Debug & Logs | Utiliser TF_LOG et TF_LOG_PATH pour diagnostiquer Terraform. |
| [20](./20-Terraform-provisioners/README.md) | Provisioners | local-exec, file, remote-exec et nettoyage. |
| [21](./21-Terraform-Exam-Cheat-Sheet/README.md) | Exam Cheat Sheet | Aide-memoire pour la certification Terraform Associate. |
| [22](./22-Terraform-Example-Codes/README.md) | Example Codes | Cas pratiques avec local, LocalStack, Docker, Kubernetes et Ansible. |
| [23](./23-Terraform-Tooling/README.md) | Terraform Tooling | Qualite et securite avec fmt, validate, tflint et checkov. |

## CI/CD

Le workflow GitHub Actions est defini dans [`.github/workflows/terraform-ci.yml`](./.github/workflows/terraform-ci.yml) et se declenche sur les pull requests vers `main`.

Le pipeline contient cinq jobs :

| Job | Role |
| --- | ---- |
| `fmt-check` | Execute `terraform fmt -check -recursive`. |
| `validate` | Execute `terraform init -backend=false` puis `terraform validate` dans les dossiers Terraform. |
| `tflint` | Initialise TFLint puis lance le lint Terraform. |
| `checkov` | Scanne le depot avec `checkov -d . --framework terraform`. |
| `plan` | Execute `terraform plan` apres succes des jobs precedents. |

Le job `plan` utilise les secrets GitHub `AWS_ACCESS_KEY_ID` et `AWS_SECRET_ACCESS_KEY` comme variables d'environnement. Ces credentials ne doivent jamais etre commits.

## Tooling

Installez ces outils avant de lancer le module 23 ou le pipeline localement :

```bash
terraform version
tflint --version
checkov --version
```

Commandes utiles :

```bash
terraform fmt -recursive
terraform validate
tflint --init && tflint
checkov -d . --framework terraform
```

## Utilisation Rapide

```bash
git clone https://github.com/bejaouibechir/terraform.git
cd terraform
cd 06-Terraform-VPC-Demo
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

Chaque module avec lab fournit :

```bash
chmod +x lab-script.sh
./lab-script.sh
```

Sous PowerShell :

```powershell
.\lab-script.ps1
```

## Ressources Officielles

| Ressource | Lien |
| --------- | ---- |
| Documentation Terraform | https://developer.hashicorp.com/terraform/docs |
| Terraform Registry | https://registry.terraform.io |
| Certification Associate | https://developer.hashicorp.com/certifications/infrastructure-automation |
| AWS Provider Docs | https://registry.terraform.io/providers/hashicorp/aws/latest/docs |
| Terraform Tutorials | https://developer.hashicorp.com/terraform/tutorials |
