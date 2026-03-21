# Étude de Cas 4 — Provider Kubernetes

## Objectif

Utiliser le provider `hashicorp/kubernetes` pour **déployer des applications sur Kubernetes** avec Terraform. Au lieu d'écrire des fichiers YAML `kubectl apply`, vous déclarez vos ressources Kubernetes en HCL, bénéficiant ainsi du state management, du plan/apply et de la gestion des dépendances de Terraform.

## Concepts Abordés

- Provider `hashicorp/kubernetes`
- Resource `kubernetes_namespace` — isolation d'environnement
- Resource `kubernetes_deployment` — gestion des pods et réplicas
- Resource `kubernetes_service` — exposition des déploiements
- Resource `kubernetes_config_map` — configuration externalisée
- Comparaison Terraform HCL vs YAML Kubernetes

## Architecture

```
Cluster Kubernetes (local : minikube / kind)
└── Namespace : terraform-demo
    ├── ConfigMap : app-config
    ├── Deployment : nginx-demo (2 réplicas)
    └── Service : nginx-service (NodePort 30080)
```

## Prérequis

1. Un cluster Kubernetes local :
   ```bash
   # Option A : minikube
   minikube start

   # Option B : kind
   kind create cluster --name terraform-demo
   ```
2. `kubectl` configuré (fichier `~/.kube/config` présent)
3. Vérification :
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

## Étapes du Lab

### 1. Initialisation

```bash
terraform init
```

### 2. Planification

```bash
terraform plan
```

### 3. Apply

```bash
terraform apply -auto-approve
```

**Output attendu :**

```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

namespace          = "terraform-demo"
deployment_name    = "nginx-demo"
service_name       = "nginx-service"
service_node_port  = 30080
```

### 4. Vérification avec kubectl

```bash
# Vérifier le namespace
kubectl get namespace terraform-demo

# Vérifier le déploiement
kubectl get deployment -n terraform-demo

# Vérifier les pods
kubectl get pods -n terraform-demo

# Vérifier le service
kubectl get service -n terraform-demo

# Accéder à l'application (minikube)
minikube service nginx-service -n terraform-demo --url
```

### 5. Mise à l'Échelle (Scale)

Modifiez `replicas = 2` → `replicas = 4` dans `02_deployment.tf`, puis :

```bash
terraform apply -auto-approve
```

Terraform ne recrée pas les pods — il effectue un **rolling update**.

### 6. Nettoyage

```bash
terraform destroy -auto-approve
```

## Terraform HCL vs YAML Kubernetes

| Aspect | Terraform HCL | YAML kubectl |
|--------|--------------|--------------|
| State management | Oui (tfstate) | Non |
| Plan avant apply | Oui | Non |
| Variables | Oui | Helm requis |
| Dependencies | Automatique | Manuel |
| Multi-cloud | Oui | Non |

## Références

- https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
- https://developer.hashicorp.com/terraform/tutorials/kubernetes
- https://kubernetes.io/docs/concepts/
