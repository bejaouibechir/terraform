# Terraform — Guide Visuel

---

## Qu'est-ce que Terraform ?

![Terraform - Introduction](C:\Users\DELL\Desktop\terraform-beginners-guide\00-Terraform-Basics\imgs\01-terraform-intro.png)

- **Terraform** = outil **Infrastructure as Code (IaC)** développé par HashiCorp
- Permet de **construire, modifier et versionner** une infrastructure de façon sûre
- Compatible avec de nombreux **cloud providers** : AWS, Azure, GCP...
- Développé en **Go** · Templates écrits en **HCL** · Extension `.tf`

---

## Comment fonctionne Terraform ?

![Terraform - Providers et APIs](C:\Users\DELL\Desktop\terraform-beginners-guide\00-Terraform-Basics\imgs\02-terraform-providers.png)

- Terraform dialogue avec les clouds via leurs **APIs**
- Les **Providers** sont des plugins qui traduisent le HCL en appels API
- Le **State file** garde en mémoire l'état réel de l'infrastructure

| Concept                       | Rôle                                             |
| ----------------------------- | ------------------------------------------------ |
| **Fichiers .tf**              | Décrivent l'infrastructure souhaitée en HCL      |
| **Providers**                 | Plugins pour chaque cloud (AWS, Azure, GCP...)   |
| **State file**                | Suivi de l'état courant de l'infra               |
| **Plan d'exécution**          | Aperçu des changements avant application         |
| **Configuration déclarative** | On décrit l'état désiré, Terraform fait le reste |
| **IaC + Versioning**          | L'infra est du code → gérable avec Git           |

---

## Workflow Terraform — 6 étapes

![Terraform - Workflow](C:\Users\DELL\Desktop\terraform-beginners-guide\00-Terraform-Basics\imgs\03-terraform-workflow.png)

| Étape           | Commande            | Description                                |
| --------------- | ------------------- | ------------------------------------------ |
| **1 · Écrire**  | —                   | Fichiers `.tf` en HCL                      |
| **2 · Init**    | `terraform init`    | Télécharge providers + configure backend   |
| **3 · Plan**    | `terraform plan`    | Prévisualise les changements sans modifier |
| **4 · Apply**   | `terraform apply`   | Applique l'infra → confirmer avec `yes`    |
| **5 · Itérer**  | —                   | Vérifier → retour étape 3 si besoin        |
| **6 · Destroy** | `terraform destroy` | Supprime toute l'infra (optionnel)         |

![](C:\Users\DELL\Desktop\terraform-beginners-guide\00-Terraform-Basics\imgs\04-resume.png)

---

## Bonnes pratiques

- Toujours utiliser **Git** pour versionner les fichiers `.tf`
- Toujours vérifier le **`terraform plan`** avant chaque `apply`
- Stocker le **state file** dans un backend distant en équipe (S3, Azure Blob...)
- Ne jamais modifier l'infrastructure **manuellement** si elle est gérée par Terraform
