# Provisioners Terraform

- Les provisioners Terraform sont utilisés pour **exécuter des scripts ou des commandes sur une resource locale ou distante** lors de sa création ou de sa destruction.
- Les provisioners permettent d'**effectuer des tâches de configuration supplémentaires** qui ne peuvent pas être réalisées directement via les arguments des resources.
- **Remarque :** HashiCorp recommande d'utiliser les provisioners en **dernier recours**. Privilégiez les outils natifs du provider (ex. : `user_data` pour EC2) lorsque c'est possible.

## Types de Provisioners

| Provisioner | Exécution | Usage typique |
|---|---|---|
| *`local-exec`* | Sur la **machine locale** qui exécute Terraform | Appels AWS CLI, enregistrement d'infos localement |
| *`file`* | Copie de fichiers vers la **resource distante** | Déposer des scripts de configuration |
| *`remote-exec`* | Sur la **resource distante** via SSH/WinRM | Installation de logiciels, configuration initiale |

---

## Exemple Pratique

**Scénario** : Déployer une instance EC2 et l'enchaîner avec les trois types de provisioners :
1. `local-exec` enregistre l'IP de l'instance localement
2. `file` copie un script de configuration sur l'instance
3. `remote-exec` exécute le script pour installer Apache

### Structure des Fichiers

```
20-Terraform-provisioners/
├── 00_provider.tf
├── 01_variables.tf
├── 02_security_group.tf
├── 03_ec2.tf
├── 04_outputs.tf
└── scripts/
    └── setup.sh
```

[00_provider.tf](./00_provider.tf)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform = "yes"
      Owner     = var.owner
    }
  }
}
```

[01_variables.tf](./01_variables.tf)

```hcl
variable "aws_region" {
  description = "Région AWS dans laquelle les resources seront créées"
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Nom de l'ingénieur qui crée les resources"
  type        = string
  default     = "Venkatesh"
}

variable "ec2_ami" {
  description = "AMI EC2 AWS Amazon Linux 2023"
  type        = string
  default     = "ami-0df435f331839b2d6"
}

variable "ec2_instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nom de la key pair AWS pour la connexion SSH"
  type        = string
  default     = "terraform-demo"
}
```

[02_security_group.tf](./02_security_group.tf)

```hcl
resource "aws_security_group" "provisioner_sg" {
  name        = "provisioner-sg"
  description = "Security Group pour autoriser SSH et HTTP"

  # Autoriser SSH entrant (port 22)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser HTTP entrant (port 80)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "provisioner-sg"
  }
}
```

[03_ec2.tf](./03_ec2.tf)

```hcl
resource "aws_instance" "myec2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.provisioner_sg.id]

  tags = {
    Name = "Linux2023-Provisioner"
  }

  # -------------------------------------------------------
  # Provisioner 1 : local-exec
  # Exécuté sur la machine locale qui lance Terraform
  # -------------------------------------------------------
  provisioner "local-exec" {
    command = "echo Instance créée - IP Publique : ${self.public_ip} >> ec2-info.txt"
  }

  # -------------------------------------------------------
  # Provisioner 2 : file
  # Copie le script local vers l'instance EC2 distante
  # -------------------------------------------------------
  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  # -------------------------------------------------------
  # Provisioner 3 : remote-exec
  # Exécuté sur l'instance EC2 distante via SSH
  # -------------------------------------------------------
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  # -------------------------------------------------------
  # Provisioner de destruction : local-exec with when=destroy
  # Exécuté sur la machine locale lors du terraform destroy
  # -------------------------------------------------------
  provisioner "local-exec" {
    when    = destroy
    command = "echo Instance ${self.public_ip} détruite le $(date) >> ec2-info.txt"
  }
}
```

[scripts/setup.sh](./scripts/setup.sh)

```bash
#!/bin/bash
# Script copié sur l'instance via le provisioner "file"
# puis exécuté via le provisioner "remote-exec"

sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

echo "<html>
  <body>
    <h1><center>Serveur déployé via Terraform Provisioners !</center></h1>
    <p><center>Instance configurée avec remote-exec + file provisioners</center></p>
  </body>
</html>" | sudo tee /var/www/html/index.html
```

[04_outputs.tf](./04_outputs.tf)

```hcl
output "ec2_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.myec2.public_ip
}

output "ec2_public_dns" {
  description = "DNS public de l'instance EC2"
  value       = "http://${aws_instance.myec2.public_dns}"
}

output "ec2_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.myec2.id
}
```

---

## Exécution Pas à Pas

- Exécutons les commandes Terraform pour comprendre le comportement des provisioners

  1. ***`terraform init`*** : *Initialiser* Terraform
  2. ***`terraform validate`*** : *Valider* le code Terraform
  3. ***`terraform fmt`*** : *Formater* le code Terraform
  4. ***`terraform plan`*** : *Réviser* le plan Terraform
  5. ***`terraform apply`*** : *Créer* des Resources avec Terraform

<details>
<summary> <i>terraform apply</i> </summary>

```shell
$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_security_group.provisioner_sg will be created
  + resource "aws_security_group" "provisioner_sg" { ... }

  # aws_instance.myec2 will be created
  + resource "aws_instance" "myec2" {
      + ami                    = "ami-0df435f331839b2d6"
      + instance_type          = "t2.micro"
      + key_name               = "terraform-demo"
      + tags                   = { + "Name" = "Linux2023-Provisioner" }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

aws_security_group.provisioner_sg: Creating...
aws_security_group.provisioner_sg: Creation complete after 2s [id=sg-0a1b2c3d4e5f67890]
aws_instance.myec2: Creating...
aws_instance.myec2: Still creating... [10s elapsed]
aws_instance.myec2: Still creating... [20s elapsed]
aws_instance.myec2: Still creating... [30s elapsed]
aws_instance.myec2: Provisioning with 'local-exec'...
aws_instance.myec2 (local-exec): Executing: ["/bin/sh" "-c" "echo Instance créée - IP Publique : 54.175.102.97 >> ec2-info.txt"]
aws_instance.myec2: Provisioning with 'file'...
aws_instance.myec2: Provisioning with 'remote-exec'...
aws_instance.myec2 (remote-exec): Connecting via SSH...
aws_instance.myec2 (remote-exec): Connected!
aws_instance.myec2 (remote-exec): + sudo yum update -y
aws_instance.myec2 (remote-exec): + sudo yum install -y httpd
aws_instance.myec2 (remote-exec): + sudo systemctl enable httpd
aws_instance.myec2 (remote-exec): + sudo systemctl start httpd
aws_instance.myec2: Creation complete after 56s [id=i-0acb2a1d622c55a02]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

ec2_id         = "i-0acb2a1d622c55a02"
ec2_public_dns = "http://ec2-54-175-102-97.compute-1.amazonaws.com"
ec2_public_ip  = "54.175.102.97"
```

</details>

- Après l'apply, vérifiez le fichier `ec2-info.txt` généré localement par `local-exec` :

```shell
$ cat ec2-info.txt
Instance créée - IP Publique : 54.175.102.97
```

- Accédez au site web déployé par `remote-exec` via l'URL fournie en output :

```shell
http://ec2-54-175-102-97.compute-1.amazonaws.com
```

---

## Comportement des Provisioners en cas d'Échec

- Par défaut, si un provisioner échoue, Terraform **marque la resource comme `tainted`** (altérée).
- Lors du prochain `terraform apply`, la resource `tainted` sera **détruite et recréée**.
- Vous pouvez modifier ce comportement avec l'argument `on_failure` :

```hcl
provisioner "remote-exec" {
  on_failure = continue  # ignore l'échec et continue
  # ou
  on_failure = fail      # comportement par défaut : échoue et marque comme tainted

  inline = [
    "sudo yum install -y httpd",
  ]
}
```

---

## Provisioners de Destruction (*`when = destroy`*)

- Les provisioners avec `when = destroy` sont exécutés **avant** que la resource soit détruite.
- Utile pour des tâches de nettoyage, désabonnement de services, archivage de logs, etc.

```hcl
provisioner "local-exec" {
  when    = destroy
  command = "echo Instance ${self.public_ip} détruite le $(date) >> ec2-info.txt"
}
```

<details>
<summary> <i>terraform destroy (provisioner when=destroy)</i> </summary>

```shell
$ terraform destroy -auto-approve

aws_instance.myec2: Destroying... [id=i-0acb2a1d622c55a02]
aws_instance.myec2: Provisioning with 'local-exec'...
aws_instance.myec2 (local-exec): Executing: ["/bin/sh" "-c" "echo Instance 54.175.102.97 détruite le Sat Jan 15 10:45:00 UTC 2024 >> ec2-info.txt"]
aws_instance.myec2: Destruction complete after 32s
aws_security_group.provisioner_sg: Destroying...
aws_security_group.provisioner_sg: Destruction complete after 1s

Destroy complete! Resources: 2 destroyed.
```

</details>

- Vérifiez le fichier `ec2-info.txt` après le destroy :

```shell
$ cat ec2-info.txt
Instance créée - IP Publique : 54.175.102.97
Instance 54.175.102.97 détruite le Sat Jan 15 10:45:00 UTC 2024
```

---

## Références :

Provisioners Terraform : https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax

remote-exec : https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

local-exec : https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

file : https://developer.hashicorp.com/terraform/language/resources/provisioners/file
