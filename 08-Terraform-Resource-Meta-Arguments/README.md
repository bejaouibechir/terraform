# Meta-Arguments de Resources Terraform

Les Meta-Arguments sont des **paramètres spéciaux** qui personnalisent la façon dont Terraform gère les `resource {}`.

## Vue d'ensemble

![Meta-Arguments - Vue d'ensemble](C:\Users\DELL\Desktop\terraform-beginners-guide\08-Terraform-Resource-Meta-Arguments\imgs\07-meta-arguments-overview.jpg)

| Meta-Argument | Rôle                                                          | Dossier             |
| ------------- | ------------------------------------------------------------- | ------------------- |
| `count`       | Crée N instances identiques indexées `[0]`, `[1]`...          | `08-01-count/`      |
| `for_each`    | Crée une instance par élément d'une `map` ou `set`            | `08-02-for_each/`   |
| `depends_on`  | Déclare une dépendance explicite entre ressources             | `08-03-depends_on/` |
| `provider`    | Sélectionne un provider avec alias (multi-région)             | `08-04-provider/`   |
| `lifecycle`   | Contrôle le cycle de vie : création, destruction, changements | `08-05-lifecycle/`  |

---

## Exemples HCL

![Meta-Arguments - Exemples HCL](C:\Users\DELL\Desktop\terraform-beginners-guide\08-Terraform-Resource-Meta-Arguments\imgs\08-meta-arguments-hcl.jpg)

### Points clés

- **`count`** — utiliser `count.index` pour différencier les instances · `count = 0` détruit la ressource
- **`for_each`** — utiliser `each.key` et `each.value` · préféré à `count` quand les instances ont une identité distincte
- **`depends_on`** — à utiliser uniquement si Terraform ne détecte pas la dépendance automatiquement via les références
- **`provider`** — nécessite un bloc `provider` avec `alias` dans `providers.tf`
- **`lifecycle`** — 4 options :
  - `create_before_destroy = true` → zéro downtime lors du remplacement
  - `prevent_destroy = true` → bloque `terraform destroy` sur cette ressource
  - `ignore_changes = [tags, ami]` → ignore certains attributs lors du plan
  - `replace_triggered_by = [aws_vpc.main]` → force recréation si la ressource référencée change
