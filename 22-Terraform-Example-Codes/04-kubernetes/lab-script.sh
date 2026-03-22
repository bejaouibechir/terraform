#!/usr/bin/env bash
# ============================================================
# Étude de Cas 4 - Provider Kubernetes
# PRÉREQUIS :
#   - minikube OU kind installé et démarré
#   - kubectl configuré (~/.kube/config présent)
#
# Démarrer minikube : minikube start
# Démarrer kind     : kind create cluster --name terraform-demo
# ============================================================

# Vérifie l'accès au cluster Kubernetes
kubectl cluster-info
kubectl get nodes

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les ressources Kubernetes via Terraform
terraform apply -auto-approve

# Affiche les outputs Terraform
terraform output

# Vérifie le namespace créé
kubectl get namespace terraform-demo

# Vérifie les pods déployés
kubectl get pods -n terraform-demo

# Vérifie les services exposés
kubectl get service -n terraform-demo

# Vérifie les ConfigMaps créées
kubectl get configmap -n terraform-demo

# Affiche l'URL d'accès à l'application (minikube uniquement)
minikube ip

# Détruit toutes les ressources Kubernetes (nettoyage)
terraform destroy -auto-approve
