# Études de Cas Terraform — Providers Avancés

Ce module regroupe des exemples pratiques utilisant des providers Terraform variés, au-delà du provider AWS classique.

## Cas d'Usage Disponibles

| # | Répertoire | Provider | Description |
|---|-----------|----------|-------------|
| 1 | `01-local-provider` | `hashicorp/local` | Génération de fichiers locaux avec Terraform |
| 2 | `02-localstack` | `hashicorp/aws` + LocalStack | Simulation de l'infrastructure AWS en local |
| 3 | `03-docker` | `kreuzwerker/docker` | Gestion de conteneurs Docker avec Terraform |
| 4 | `04-kubernetes` | `hashicorp/kubernetes` | Déploiement d'applications sur Kubernetes |
| 5 | `05-ansible` | `hashicorp/aws` + Ansible | Intégration Terraform + Ansible (provisioning) |

## Prérequis Communs

- Terraform >= 1.0 installé
- Pour `02-localstack` : [LocalStack](https://localstack.cloud/) en cours d'exécution (`localstack start`)
- Pour `03-docker` : Docker Desktop installé et démarré
- Pour `04-kubernetes` : un cluster Kubernetes local (minikube, kind) et `kubectl` configuré
- Pour `05-ansible` : Ansible installé, credentials AWS et une key pair SSH

## Références

- https://registry.terraform.io/providers/hashicorp/local/latest/docs
- https://docs.localstack.cloud/user-guide/integrations/terraform/
- https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
- https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
