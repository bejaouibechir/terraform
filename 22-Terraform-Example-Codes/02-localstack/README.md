# Étude de Cas 2 — LocalStack (Simulateur AWS Local)

## Objectif

Utiliser **LocalStack** pour simuler l'infrastructure AWS localement, sans frais et sans connexion Internet. Terraform interagit exactement comme avec le vrai AWS, mais toutes les ressources sont émulées sur votre machine.

## Concepts Abordés

- Configuration du provider AWS pour pointer vers LocalStack
- Création de ressources AWS simulées : VPC, Subnet, S3 Bucket
- Différence entre LocalStack Community (gratuit) et Pro (payant)
- Vérification des ressources avec `awslocal` CLI

## Architecture

```
LocalStack (http://localhost:4566)
├── VPC          (aws_vpc)
├── Subnet       (aws_subnet)
└── S3 Bucket    (aws_s3_bucket)
```

## Prérequis

1. **Docker Desktop** installé et démarré
2. **LocalStack** installé :
   ```bash
   pip install localstack
   localstack start   # démarre LocalStack dans Docker
   ```
3. **awslocal** CLI (optionnel, pour vérification) :
   ```bash
   pip install awscli-local
   ```

> LocalStack écoute sur `http://localhost:4566` pour tous les services AWS.

## Configuration Clé du Provider

```hcl
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"          # Valeur factice pour LocalStack
  secret_key                  = "test"          # Valeur factice pour LocalStack
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
  }
}
```

## Étapes du Lab

### 1. Démarrer LocalStack

```bash
localstack start
# ou en arrière-plan :
localstack start -d
```

### 2. Vérifier que LocalStack est prêt

```bash
curl http://localhost:4566/_localstack/health | jq .
```

### 3. Initialisation Terraform

```bash
terraform init
terraform fmt && terraform validate
```

### 4. Apply

```bash
terraform apply -auto-approve
```

**Output attendu :**

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

vpc_id     = "vpc-xxxxxxxx"
subnet_id  = "subnet-xxxxxxxx"
bucket_name = "tf-localstack-demo-bucket"
```

### 5. Vérification avec awslocal

```bash
awslocal ec2 describe-vpcs --filters Name=tag:Name,Values=MyVPC-LocalStack
awslocal s3 ls
```

### 6. Nettoyage

```bash
terraform destroy -auto-approve
localstack stop
```

## Références

- https://docs.localstack.cloud/user-guide/integrations/terraform/
- https://github.com/localstack/localstack
- https://docs.localstack.cloud/references/configuration/
