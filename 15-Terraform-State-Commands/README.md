# Commandes State Terraform

- Les commandes *state* Terraform sont utilisées
  - Pour **inspecter**, **modifier** et **gérer** le state Terraform
  - Pour **suivre l'état** de votre infrastructure
  - **Effectuer des modifications sécurisées** au fichier state terraform

## Liste des Commandes State Terraform

### Inspection du State

1. *`terraform state list`* : Liste toutes les resources dans le state Terraform.

2. *`terraform state show`* : Affiche les attributs d'une resource spécifique dans le state Terraform.

3. *`terraform state refresh`* : Met à jour le fichier state Terraform avec l'état réel de l'infrastructure gérée.

4. *`terraform state version`* : Affiche la version du format du fichier state Terraform.

### Déplacement de Resources

5. *`terraform state mv`* : Déplace un élément dans le state Terraform d'un ID à un autre. Utile pour renommer des resources.

6. *`terraform state rm`* : Supprime une instance de resource du state Terraform. À utiliser avec précaution, car cela ne détruit pas l'infrastructure associée.

7. *`terraform state replace-provider`* : Remplace un provider dans le state Terraform. Utile pour modifier les configurations de provider.

### Reprise après Sinistre

8. *`terraform state pull`* : Récupère l'état courant et l'affiche sur stdout.

9. *`terraform state push`* : Utilisé pour télécharger un fichier state local vers un backend de state distant.

10. *`terraform force-unlock`* : Libère un verrou bloqué sur le fichier state, ce qui peut se produire si une opération Terraform précédente ne s'est pas terminée correctement et que le verrou n'a pas été libéré

### Forcer la Recréation

11. *`terraform state taint`* : Marque une instance de resource comme "tainted" (altérée), la forçant à être détruite et recréée lors du prochain apply.

12. *`terraform state un-taint`* : Supprime l'état "tainted" d'une instance de resource, lui permettant d'être gérée normalement à nouveau.

## Références :

https://developer.hashicorp.com/terraform/cli/state

https://developer.hashicorp.com/terraform/cli/state/inspect

https://developer.hashicorp.com/terraform/cli/state/move

https://developer.hashicorp.com/terraform/cli/state/recover
