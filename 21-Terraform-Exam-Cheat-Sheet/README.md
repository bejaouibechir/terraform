# Aide-mémoire pour l'Examen de Certification Terraform

## Terraform

- **Cloud-agnostic** :
  
  - Gère l'infrastructure sur différents providers cloud
  - Exemple : AWS, Azure, Google Cloud et les environnements on-premises.

- **Déclaratif** :
  
  - Utilise le HashiCorp Configuration Language (HCL) pour décrire l'état désiré de l'infrastructure.
  - Spécifie les resources, configurations et relations dans le code.
  - Terraform détermine les actions nécessaires pour atteindre l'état désiré et les exécute.

- **Immuable** :
  
  - Traite l'infrastructure comme immuable.
  - Crée de nouvelles resources ou remplace les existantes pour correspondre à l'état désiré.
  - Ne modifie pas les resources existantes ; crée une nouvelle version basée sur la configuration mise à jour.
  - Remplace l'ancienne infrastructure par une nouvelle basée sur la configuration mise à jour.

- **Idempotence** :
  
  - Garantit que l'application de la même configuration plusieurs fois produit le même résultat qu'une seule application, réduisant le risque de dérive de configuration.

- **Contrôle de Version** :
  
  - Stockez les configurations d'infrastructure dans des systèmes de contrôle de version (ex. : Git) pour suivre les changements, faciliter la collaboration et permettre les rollbacks.

- **Infrastructure auto-descriptive**
  
  - L'infrastructure peut être décrite de manière à ce que son objectif, sa configuration et ses dépendances soient clairs et compréhensibles sans avoir besoin d'inspecter l'infrastructure réelle.

- **Workflow Terraform**
  
    1\. *`Écrire un fichier de configuration Terraform`* (.tf)
  
  2. *`terraform init`* : **Initialisation** du répertoire de travail Terraform
  3. *`terraform plan`* : **Planification** des changements d'infrastructure
  4. *`terraform apply`* : **Application** des changements avec terraform apply pour créer la nouvelle infrastructure

- La configuration Terraform peut être écrite en
  
  - HashiCorp Configuration Language (HCL)
  - JSON

- **Liste de tous les OS Supportés**
  
  - macOS
  - Windows
  - Linux
    - Ubuntu/Debian
    - CentOS/RHEL
    - Fedora
    - Amazon Linux
  - FreeBSD
  - OpenBSD
  - Solaris
  - Plus de détails : https://developer.hashicorp.com/terraform/install

## bloc provider

- Un **provider est un plugin** qui permet à Terraform d'interagir avec un provider cloud ou un service spécifique
- Un bloc de configuration provider n'est **PAS requis dans chaque configuration Terraform**.
- Le provider est uniquement requis lorsque vous utilisez un provider spécifique pour gérer des resources
- Les providers **peuvent être écrits par des individus**
- Les providers **peuvent être maintenus par une communauté d'utilisateurs**
- **Certains providers sont maintenus par HashiCorp**
- **Les grands fournisseurs cloud et non-cloud peuvent écrire, maintenir** ou collaborer sur des providers Terraform

## provisioners

- *`remote-exec`*
  - Exécute des **commandes sur une resource distante via SSH ou WinRM** après sa création.
  - Peut être utilisé pour la configuration initiale, l'installation de logiciels ou d'autres tâches.
  - Exemple : exécuter des commandes shell ou PS sur un EC2 distant
- *`local-exec`*
  - Exécute des **commandes sur la machine exécutant Terraform**,
  - Utilisé pour des tâches ne pouvant pas être effectuées sur la resource distante.
  - Exemple : exécuter des commandes aws cli depuis la machine locale exécutant Terraform
- *`file`*
  - **Copie des fichiers ou répertoires** depuis la machine exécutant Terraform vers la resource nouvellement créée
  - Le provisioner file supporte les types de connexion ***`ssh`*** et ***`winrm`***

## fichier state *`terraform.tfstate`*

- Le nom du fichier state est *`terraform.tfstate`*
- Un fichier qui **stocke l'état courant** de l'infrastructure gérée par Terraform
- L'argument **"description"** n'est **PAS stocké dans le fichier state**, il est utilisé pour fournir des descriptions lisibles par l'humain
- *`terraform.tfstate`* **ne correspond PAS** toujours à votre infrastructure actuellement déployée. Il est possible que quelqu'un ait apporté des modifications manuelles à votre infrastructure
- Les `noms d'utilisateur` et `mots de passe` référencés dans le code Terraform, même en tant que variables, se retrouveront en **texte clair dans le fichier state**
- L'**emplacement par défaut** de *`terraform.tfstate`* est le **répertoire de travail courant** dans lequel Terraform a été exécuté

## Commandes Terraform

- *`terraform init`*

- *`terraform plan`*

- *`terraform fmt`*

- *`terraform validate`*

- *`terraform apply`*

- *`terraform apply -replace=aws_instance.{INSTANCE_NAME}`*
  
  - recrée la resource lors de l'apply (remplacement de `terraform taint`)

- *`terraform refresh`*
  
  - **Met à jour le fichier state** pour refléter l'état courant de l'infrastructure
  - **Ne traite pas le fichier de configuration**

- *`terraform plan -destroy`*

- *`terraform destroy`*

- *`terraform get`*

- *`terraform state list`*

- *`terraform force-unlock`*
  
  - utilisez *`force-unlock`* uniquement lorsque le déverrouillage automatique échoue

## workspace distant

- Vous pouvez avoir un seul workspace distant et mapper plusieurs configurations (plusieurs fichiers state)

## Journalisation Terraform

- **`TF_LOG`** - Spécifie le niveau de journalisation

- **`TF_LOG_PATH`** - Spécifie le chemin du fichier de log

- Valeurs disponibles pour TF_LOG
  
  - **TRACE** : Fournit la journalisation **la plus détaillée**, c'est le **niveau le plus élevé**
  - **DEBUG** : Fournit une journalisation de niveau debug
  - **INFO**  : Fournit une journalisation informative
  - **WARN**  : Fournit des messages d'avertissement
  - **ERROR** : Fournit uniquement des messages d'erreur

- Plus de détails : [Terraform-Debug](../19-Terraform-Debug/README.md)

## Workspaces Terraform

- Un workspace Terraform permet de **gérer différents ensembles de resources d'infrastructure** en utilisant la **même configuration Terraform** en isolant les fichiers state.
- **Chaque workspace possède son propre fichier state**, permettant de travailler sur différents environnements (dev, staging, prod) sans affecter les autres.
- Terraform démarre avec un workspace *par défaut* nommé **`default`** que vous ne pouvez pas supprimer.
- Les workspaces **ne remplacent pas les configurations Terraform séparées** si vous avez besoin de credentials ou de contrôles d'accès différents par environnement.
- **Remarque :** Les workspaces Terraform CLI sont différents des workspaces dans Terraform Cloud.

**Commandes Workspace :**

- *`terraform workspace new <nom>`* : Crée un nouveau workspace

- *`terraform workspace select <nom>`* : Bascule vers un workspace existant

- *`terraform workspace list`* : Liste tous les workspaces disponibles

- *`terraform workspace show`* : Affiche le workspace courant

- *`terraform workspace delete <nom>`* : Supprime un workspace

- plus de détails : [Terraform-Workspaces](../16-Terraform-Workspaces/README.md)

## Modules Terraform

- Une collection de resources constituant un élément spécifique d'infrastructure
- Un groupe de resources liées
- Les modules Terraform sont utilisés pour
  - **Organiser** la configuration
  - **Encapsuler** la configuration
  - **Réutiliser** la configuration

## Terraform sentinel

- policy as code
- Peut être utilisé pour appliquer des politiques de conformité et de gouvernance avant toute modification d'infrastructure

## Terraform Cloud Free Tier

- Les éléments suivants sont disponibles
  
  - Private Module Registry
  - VCS Connection
  - Single Sign-On (SSO)
  - Exécution Terraform distante

- Les éléments suivants **ne sont PAS** disponibles
  
  - Gestion des équipes
  - Journalisation au niveau application
  - Audit Logging
  - Provisionnement sans code

- **Contraintes de Version Terraform**
  
  | Contrainte                                    | Description                                                                                                                                                | Exemple    |
  | --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
  | `>= 1.0.0` (Supérieur ou Égal À)              | Autorise toute version supérieure ou égale à `1.0.0`, telle que `1.0.0`, `1.0.1`, `1.1.0`, etc.                                                            | `>= 1.0.0` |
  | `<= 1.0.0` (Inférieur ou Égal À)              | Autorise toute version inférieure ou égale à `1.0.0`, telle que `1.0.0`, `0.9.9`, etc.                                                                     | `<= 1.0.0` |
  | `~> 1.0.0` (Contrainte de Version Pessimiste) | Autorise toute version égale à `1.0.0`, ou supérieure, mais uniquement jusqu'à la prochaine version majeure, telle que `1.0.0`, `1.0.1`, mais pas `1.1.0`. | `~> 1.0.0` |
  | `= 1.0.0` (Version Exacte)                    | Autorise uniquement la version exacte `1.0.0`.                                                                                                             | `= 1.0.0`  |
  | `!= 1.0.0` (Différent De)                     | Exclut la version `1.0.0` mais autorise toute autre version.                                                                                               | `!= 1.0.0` |

- **Types Terraform**
  
  | Type     | Description                                     | Exemple                              |
  | -------- | ----------------------------------------------- | ------------------------------------ |
  | `string` | Représente une chaîne de texte.                 | `"hello"`, `"world"`                 |
  | `number` | Représente une valeur numérique.                | `5`, `10.5`                          |
  | `list`   | Représente une liste de valeurs.                | `[1, 2, 3]`, `["a", "b", "c"]`       |
  | `map`    | Représente une collection de paires clé-valeur. | `{key1 = "value1", key2 = "value2"}` |

- **Fonctions Terraform**
  
  | Fonction                           | Description                                                                                     | Exemple                                                                  |
  | ---------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
  | `element(list, index)`             | Retourne l'élément à l'index spécifié dans une liste.                                           | `element([1, 2, 3], 1)` retourne `2`                                     |
  | `format(format_string, arguments)` | Formate une chaîne en utilisant des espaces réservés et des valeurs.                            | `format("Hello, %s!", "world")` retourne `"Hello, world!"`               |
  | `join(separator, list)`            | Joint les éléments d'une liste en une seule chaîne en utilisant un séparateur.                  | `join(", ", ["a", "b", "c"])` retourne `"a, b, c"`                       |
  | `lookup(map, key, default)`        | Recherche une valeur dans un map en fonction d'une clé, avec une valeur par défaut optionnelle. | `lookup({a = "apple", b = "banana"}, "a", "default")` retourne `"apple"` |

- **Types Structurels :**
  
  | Type     | Description                                             | Exemple                   |
  | -------- | ------------------------------------------------------- | ------------------------- |
  | `string` | Représente du texte, comme des mots ou des phrases.     | `"hello"`, `"world"`      |
  | `number` | Représente des valeurs numériques, entiers ou décimaux. | `5`, `10.5`               |
  | `bool`   | Représente des valeurs booléennes, vrai ou faux.        | `true`, `false`           |
  | `list`   | Représente une liste de valeurs du même type.           | `[1, 2, 3]`, `["a", "b"]` |

- **Types Complexes :**
  
  | Type     | Description                                                                                          | Exemple                                       |
  | -------- | ---------------------------------------------------------------------------------------------------- | --------------------------------------------- |
  | `map`    | Représente une collection de paires clé-valeur, similaire à un dictionnaire.                         | `{key1 = "value1", key2 = "value2"}`          |
  | `object` | Représente une structure complexe avec plusieurs attributs, chacun ayant son propre type.            | `{name = "John", age = 30, is_active = true}` |
  | `tuple`  | Représente une collection de taille fixe d'éléments, où chaque élément peut avoir un type différent. | `["apple", 1, true]`                          |
  | `set`    | Représente une collection d'éléments uniques.                                                        | `["apple", "banana", "cherry"]`               |

- ### Différents niveaux de Terraform Cloud
  
  | Fonctionnalité                                  | HCP Free                                       | HCP Standard                                   | HCP Plus | HCP Enterprise |
  | ----------------------------------------------- | ---------------------------------------------- | ---------------------------------------------- | -------- | -------------- |
  | Infrastructure as code (HCL, CDKTF)             | Oui                                            | Oui                                            | Oui      | Oui            |
  | Workspaces                                      | Oui                                            | Oui                                            | Oui      | Oui            |
  | Variables                                       | Oui                                            | Oui                                            | Oui      | Oui            |
  | Runs (plan et apply séparés)                    | Oui                                            | Oui                                            | Oui      | Oui            |
  | Providers                                       | Oui                                            | Oui                                            | Oui      | Oui            |
  | Modules                                         | Oui                                            | Oui                                            | Oui      | Oui            |
  | Registre public                                 | Oui                                            | Oui                                            | Oui      | Oui            |
  | Import piloté par la config                     | Oui                                            | Oui                                            | Oui      | Oui            |
  | Stockage du state distant                       | Oui                                            | Oui                                            | Oui      | Oui            |
  | **Connexion VCS**                               | Oui                                            | Oui                                            | Oui      | Oui            |
  | Projets                                         | Oui                                            | Oui                                            | Oui      | Oui            |
  | Stockage sécurisé des variables                 | Oui                                            | Oui                                            | Oui      | Oui            |
  | **Exécutions distantes (plan & apply)**         | Oui                                            | Oui                                            | Oui      | Oui            |
  | Registre privé                                  | Oui                                            | Oui                                            | Oui      | Oui            |
  | Publication de modules avec tests intégrés      | 5 modules                                      | 10 modules                                     | Illimité | Oui            |
  | **Gestion des équipes**                         | Non                                            | Oui                                            | Oui      | Oui            |
  | **Provisionnement sans code**                   | Non                                            | Non                                            | Oui      | Oui            |
  | Tests de modules générés                        | Non                                            | Non                                            | Bêta     | Non            |
  | Partage de registre inter-organisations         | Non                                            | Non                                            | Non      | Oui            |
  | Gestion des workspaces                          | Oui                                            | Oui                                            | Oui      | Oui            |
  | Explorateur de workspaces                       | Oui                                            | Oui                                            | Oui      | Non            |
  | **Audit logging**                               | Non                                            | Non                                            | Oui      | Oui            |
  | Détection de dérive                             | Non                                            | Non                                            | Oui      | Oui            |
  | Validation continue                             | Non                                            | Non                                            | Oui      | Oui            |
  | Workspaces éphémères                            | Non                                            | Non                                            | Oui      | Oui            |
  | Métriques runtime (Prometheus)                  | Non                                            | Non                                            | Non      | Oui            |
  | Credentials dynamiques de provider              | Oui                                            | Oui                                            | Oui      | Oui            |
  | Policy as code (Sentinel et OPA)                | 1 Policy set, 5 Policies                       | 1 Policy set, 5 Policies                       | Illimité | Oui            |
  | Policy sets versionnés                          | Non                                            | Non                                            | Oui      | Oui            |
  | Niveau d'application des policies : Consultatif | Illimité                                       | Illimité                                       | Illimité | Oui            |
  | Niveau d'application des policies : Obligatoire | 1 Obligatoire                                  | 1 Obligatoire                                  | Illimité | Oui            |
  | Run tasks                                       | 1 intégration Run task, 10 Workspaces attachés | 1 intégration Run task, 10 Workspaces attachés | Illimité | Oui            |
  | Run tasks : application consultative            | Illimité                                       | Illimité                                       | Illimité | Oui            |
  | Run tasks : application obligatoire             | 1 Obligatoire                                  | 1 Obligatoire                                  | Illimité | Oui            |
  | Installation auto-hébergée                      | Non                                            | Non                                            | Non      | Oui            |
  | Déploiement en réseau isolé                     | Non                                            | Non                                            | Non      | Oui            |
  | **Journalisation au niveau application**        | Non                                            | Non                                            | Non      | Oui            |
  | Transfert de logs                               | Non                                            | Non                                            | Non      | Oui            |
  | API des pistes d'audit                          | Non                                            | Non                                            | Oui      | Non            |
  | **Single sign-on**                              | Oui                                            | Oui                                            | Oui      | Oui            |
  | Support pour les intégrations ServiceNow        | Non                                            | Non                                            | Oui      | Oui            |
  | Run triggers                                    | Oui                                            | Oui                                            | Oui      | Oui            |
  | Concurrence                                     | 1                                              | 3                                              | 10       | Illimité       |
  | Agents auto-hébergés                            | 1                                              | 1                                              | 10       | Illimité       |
  | Scale-out actif/actif                           | Non                                            | Non                                            | Non      | Oui            |
  | Communauté                                      | Oui                                            | Oui                                            | Oui      | Oui            |
  | Support et services premium                     | Non                                            | Oui                                            | Oui      | Oui            |

## Types et fonctions Terraform

**Types Terraform**

| Type     | Description                                     | Exemple                              |
| -------- | ----------------------------------------------- | ------------------------------------ |
| `string` | Représente une chaîne de texte.                 | `"hello"`, `"world"`                 |
| `number` | Représente une valeur numérique.                | `5`, `10.5`                          |
| `list`   | Représente une liste de valeurs.                | `[1, 2, 3]`, `["a", "b", "c"]`       |
| `map`    | Représente une collection de paires clé-valeur. | `{key1 = "value1", key2 = "value2"}` |

**Fonctions Terraform**

| Fonction                           | Description                                                                                     | Exemple                                                                  |
| ---------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `element(list, index)`             | Retourne l'élément à l'index spécifié dans une liste.                                           | `element([1, 2, 3], 1)` retourne `2`                                     |
| `format(format_string, arguments)` | Formate une chaîne en utilisant des espaces réservés et des valeurs.                            | `format("Hello, %s!", "world")` retourne `"Hello, world!"`               |
| `join(separator, list)`            | Joint les éléments d'une liste en une seule chaîne en utilisant un séparateur.                  | `join(", ", ["a", "b", "c"])` retourne `"a, b, c"`                       |
| `lookup(map, key, default)`        | Recherche une valeur dans un map en fonction d'une clé, avec une valeur par défaut optionnelle. | `lookup({a = "apple", b = "banana"}, "a", "default")` retourne `"apple"` |

**Types Structurels :**

| Type     | Description                                             | Exemple                   |
| -------- | ------------------------------------------------------- | ------------------------- |
| `string` | Représente du texte, comme des mots ou des phrases.     | `"hello"`, `"world"`      |
| `number` | Représente des valeurs numériques, entiers ou décimaux. | `5`, `10.5`               |
| `bool`   | Représente des valeurs booléennes, vrai ou faux.        | `true`, `false`           |
| `list`   | Représente une liste de valeurs du même type.           | `[1, 2, 3]`, `["a", "b"]` |

**Types Complexes :**

| Type     | Description                                                                                          | Exemple                                       |
| -------- | ---------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| `map`    | Représente une collection de paires clé-valeur, similaire à un dictionnaire.                         | `{key1 = "value1", key2 = "value2"}`          |
| `object` | Représente une structure complexe avec plusieurs attributs, chacun ayant son propre type.            | `{name = "John", age = 30, is_active = true}` |
| `tuple`  | Représente une collection de taille fixe d'éléments, où chaque élément peut avoir un type différent. | `["apple", 1, true]`                          |
| `set`    | Représente une collection d'éléments uniques.                                                        | `["apple", "banana", "cherry"]`               |
