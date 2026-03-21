# Étude de Cas 5 — Intégration Terraform + Ansible

## Objectif

Apprendre à combiner **Terraform** (provisioning d'infrastructure) et **Ansible** (configuration et déploiement logiciel) dans un workflow unifié. Terraform crée l'EC2, puis appelle automatiquement Ansible via le provisioner `local-exec` pour configurer l'instance.

## Concepts Abordés

- Provisioner `local-exec` pour déclencher Ansible depuis Terraform
- Génération dynamique d'un fichier d'inventaire Ansible avec `local_file`
- Attente de disponibilité SSH avant de lancer Ansible (`null_resource`)
- Playbook Ansible pour installer et configurer un serveur web
- Séparation des responsabilités : Terraform = infra, Ansible = config

## Architecture

```
Terraform Apply
├── 1. Crée le Security Group (SSH + HTTP)
├── 2. Crée l'instance EC2
├── 3. Génère inventory.ini (IP de l'EC2)
├── 4. Attend que SSH soit disponible
└── 5. Lance : ansible-playbook -i inventory.ini playbook.yml
           └── Installe Apache HTTPD sur l'EC2
```

## Prérequis

1. **Compte AWS** avec credentials configurés
2. **Key pair SSH** créée dans AWS :
   ```bash
   aws ec2 create-key-pair --key-name terraform-ansible-key \
     --query 'KeyMaterial' --output text > ~/.ssh/terraform-ansible-key.pem
   chmod 400 ~/.ssh/terraform-ansible-key.pem
   ```
3. **Ansible** installé sur la machine locale :
   ```bash
   pip install ansible
   # ou
   sudo apt install ansible
   ```
4. Adaptez `var.key_name` et `var.private_key_path` à votre configuration.

## Fichiers

| Fichier | Rôle |
|---------|------|
| `00_provider.tf` | Provider AWS |
| `01_variables.tf` | Variables (région, key pair, AMI) |
| `02_security_group.tf` | SG avec SSH (22) et HTTP (80) |
| `03_ec2.tf` | Instance EC2 + génération inventaire |
| `04_ansible.tf` | null_resource : attente SSH + appel Ansible |
| `05_outputs.tf` | IP publique, DNS, commande SSH |
| `playbook.yml` | Playbook Ansible : installation Apache |

## Étapes du Lab

### 1. Adapter les variables

Éditez `01_variables.tf` ou créez un fichier `terraform.tfvars` :

```hcl
key_name         = "terraform-ansible-key"
private_key_path = "~/.ssh/terraform-ansible-key.pem"
```

### 2. Initialisation

```bash
terraform init
terraform plan
```

### 3. Apply

```bash
terraform apply -auto-approve
```

Terraform :
1. Crée l'instance EC2
2. Génère `inventory.ini` avec l'IP publique
3. Attend que le port 22 soit accessible
4. Lance `ansible-playbook playbook.yml`

### 4. Vérification

```bash
# Voir l'IP de l'instance
terraform output ec2_public_ip

# Tester le serveur web
curl http://$(terraform output -raw ec2_public_ip)

# Se connecter en SSH
ssh -i ~/.ssh/terraform-ansible-key.pem ec2-user@$(terraform output -raw ec2_public_ip)
```

### 5. Nettoyage

```bash
terraform destroy -auto-approve
```

## Références

- https://docs.ansible.com/ansible/latest/user_guide/
- https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
- https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
