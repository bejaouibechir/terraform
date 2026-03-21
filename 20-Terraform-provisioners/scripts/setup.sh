#!/bin/bash
# Script de configuration du serveur web Apache
# Copié sur l'instance EC2 via le provisioner "file"
# puis exécuté via le provisioner "remote-exec"

# Mise à jour du système
sudo yum update -y

# Installation d'Apache
sudo yum install -y httpd

# Activer et démarrer le service Apache
sudo systemctl enable httpd
sudo systemctl start httpd

# Créer une page d'accueil simple
echo "<html>
  <body>
    <h1><center>Serveur déployé via Terraform Provisioners !</center></h1>
    <p><center>Instance configurée avec remote-exec + file provisioners</center></p>
  </body>
</html>" | sudo tee /var/www/html/index.html
