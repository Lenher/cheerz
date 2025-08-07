# Spring Boot Docker Application - Cheerz

Application Spring Boot conteneurisée avec déploiement sur Google App Engine.

## Instructions de déploiement

### Prérequis
- Compte Google Cloud Platform avec projet configuré
- Repository GitHub avec les secrets et variables configurés
- Terraform pour l'infrastructure (optionnel)

### Configuration GitHub Repository

#### Variables (Settings > Secrets and variables > Actions > Variables)
```
GCP_PROJECT_ID=natural-furnace-468312-u6
GCP_REGION=europe-west1
GCP_REPOSITORY=spring-boot-apps
IMAGE_NAME=gs-spring-boot-docker
```

#### Secrets (Settings > Secrets and variables > Actions > Secrets)
```
GCP_SA_KEY=<JSON key du service account GCP>
```

### Déploiement manuel
Le déploiement se fait **manuellement** via l'interface GitHub Actions :

1. Aller dans l'onglet **"Actions"** du repository
2. Sélectionner **"Build and Deploy Application"**
3. Cliquer sur **"Run workflow"** 
4. Le pipeline exécute automatiquement dans l'ordre :
   - **Build et tests** de l'application Spring Boot
   - **Analyse de sécurité Trivy** (bloque si vulnérabilités critiques)
   - **Déploiement sur App Engine** (si analyse de sécurité OK)

## URL de l'application déployée

**Application live :** https://natural-furnace-468312-u6.appspot.com/

L'application répond "Hello Docker World" sur l'endpoint racine.

## Justification du choix de plateforme

**Google App Engine** a été choisi pour son approche **serverless** : pas de gestion du **scaling**, pas de gestion du **load balancing**, et **URL publique sans configuration IAM**. Kubernetes ou des VMs seraient surdimensionnés pour cette petite application. Cela permet de se concentrer uniquement sur le code applicatif.

## Améliorations possibles

- **Déploiement automatique** sur push (au lieu de manuel)
- **Tests d'intégration** avec base de données H2
- **Monitoring** avec Spring Boot Actuator
- **Multi-environnements** (dev/prod)