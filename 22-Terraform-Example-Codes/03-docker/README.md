# Étude de Cas 3 — Provider Docker

## Objectif

Utiliser le provider `kreuzwerker/docker` pour **gérer des conteneurs Docker** avec Terraform. Cela permet de versionner et d'automatiser le cycle de vie de vos conteneurs (images, réseaux, volumes) avec le même outil que votre infrastructure cloud.

## Concepts Abordés

- Provider `kreuzwerker/docker`
- Resource `docker_image` — téléchargement d'images Docker
- Resource `docker_container` — création et configuration de conteneurs
- Resource `docker_network` — création de réseaux Docker
- Resource `docker_volume` — gestion des volumes persistants
- Mapping de ports, variables d'environnement, montage de volumes

## Architecture

```
Docker Engine (socket local)
├── Réseau : terraform-network (bridge)
├── Volume  : nginx-data
└── Conteneurs :
    ├── nginx  (image: nginx:latest,  port 8080→80)
    └── redis  (image: redis:alpine,  port 6379→6379)
```

## Prérequis

- Docker Desktop installé et démarré
- Docker Engine accessible via le socket Unix/Windows

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
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

nginx_container_id   = "a1b2c3d4e5f6..."
nginx_url            = "http://localhost:8080"
redis_container_id   = "f6e5d4c3b2a1..."
network_name         = "terraform-network"
```

### 4. Vérification

```bash
# Vérifier les conteneurs Docker
docker ps

# Tester nginx
curl http://localhost:8080

# Vérifier le réseau
docker network inspect terraform-network
```

### 5. Nettoyage

```bash
terraform destroy -auto-approve
```

> Terraform supprime les conteneurs, le réseau et le volume automatiquement.

## Références

- https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
- https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container
- https://docs.docker.com/engine/api/
