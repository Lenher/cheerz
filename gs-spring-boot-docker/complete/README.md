# Spring Boot Docker Application

Application Spring Boot conteneurisée avec CI/CD vers Google Cloud Platform.

## Structure du projet

```
complete/
├── src/
│   ├── main/java/hello/       # Code source de l'application
│   └── test/java/hello/        # Tests
├── Dockerfile                   # Configuration Docker
├── app.yaml                     # Configuration App Engine
├── pom.xml                      # Configuration Maven
└── build.gradle                 # Configuration Gradle
```

## Développement local

### Prérequis
- Java 17
- Docker
- Maven ou Gradle

### Construction et exécution

#### Avec Gradle
```bash
# Construction
./gradlew build

# Tests
./gradlew test

# Exécution
./gradlew bootRun
```

#### Avec Maven
```bash
# Construction
./mvnw package

# Tests
./mvnw test

# Exécution
./mvnw spring-boot:run
```

L'application sera accessible sur http://localhost:8080

## Docker

### Construction de l'image

#### Méthode 1: Spring Boot Buildpack (recommandé)
```bash
# Avec Gradle
./gradlew bootBuildImage --imageName=myapp:latest

# Avec Maven
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=myapp:latest
```

#### Méthode 2: Dockerfile traditionnel
```bash
# Extraction des dépendances (pour optimiser les layers)
mkdir -p build/dependency
(cd build/dependency; jar -xf ../libs/*.jar)

# Construction de l'image
docker build --build-arg DEPENDENCY=build/dependency -t myapp:latest .
```

### Exécution du conteneur
```bash
docker run -p 8080:8080 myapp:latest
```

## CI/CD avec GitHub Actions

### Workflows disponibles

1. **app-deploy.yml** : Déploiement sur App Engine
2. **cloud-run-deploy.yml** : Déploiement sur Cloud Run (recommandé pour les conteneurs)

### Configuration requise

#### Variables GitHub (Settings > Secrets and variables > Actions > Variables)
- `GCP_PROJECT_ID` : ID du projet GCP
- `GCP_REGION` : Région GCP (ex: europe-west1)
- `GCP_REPOSITORY` : Nom du repository Artifact Registry
- `IMAGE_NAME` : Nom de l'image Docker

#### Secrets GitHub (Settings > Secrets and variables > Actions > Secrets)
- `GCP_SA_KEY` : Clé JSON du compte de service GCP

### Pipeline CI/CD

Le pipeline effectue les étapes suivantes :

1. **Build** : Construction de l'application avec Gradle/Maven
2. **Test** : Exécution des tests unitaires et d'intégration
3. **Docker Build** : Construction de l'image Docker
4. **Push Registry** : Push vers Google Artifact Registry
5. **Deploy** : Déploiement sur App Engine ou Cloud Run

### Déclenchement

- **Automatique** : Push sur la branche `main`
- **Manuel** : Via l'interface GitHub Actions (workflow_dispatch)

## Déploiement

### App Engine
```bash
# Déploiement manuel
gcloud app deploy app.yaml \
  --image-url=[REGION]-docker.pkg.dev/[PROJECT_ID]/[REPOSITORY]/[IMAGE_NAME]:latest
```

### Cloud Run
```bash
# Déploiement manuel
gcloud run deploy spring-boot-app \
  --image=[REGION]-docker.pkg.dev/[PROJECT_ID]/[REPOSITORY]/[IMAGE_NAME]:latest \
  --region=[REGION] \
  --port=8080 \
  --allow-unauthenticated
```

## Architecture

### Technologies utilisées
- **Spring Boot 3.3.0** : Framework d'application
- **Java 17** : Langage de programmation
- **Docker** : Conteneurisation
- **Google Artifact Registry** : Stockage d'images Docker
- **App Engine / Cloud Run** : Hébergement de l'application
- **GitHub Actions** : CI/CD

### Points d'entrée API
- `GET /` : Retourne "Hello Docker World"

## Tests

Les tests utilisent JUnit 5 et Spring Boot Test :
```bash
# Exécution des tests
./gradlew test

# Avec rapport de couverture
./gradlew test jacocoTestReport
```

## Monitoring

### Logs
```bash
# App Engine
gcloud app logs tail -s default

# Cloud Run
gcloud run services logs read spring-boot-app --region=[REGION]
```

### Métriques
Disponibles dans la console GCP :
- Cloud Console > App Engine > Dashboard
- Cloud Console > Cloud Run > Services

## Dépannage

### L'image Docker ne se construit pas
- Vérifier la version de Java (doit être 17)
- S'assurer que le JAR est bien généré dans `build/libs/` ou `target/`

### Le déploiement échoue
- Vérifier les permissions du compte de service
- Vérifier que les APIs GCP sont activées
- Consulter les logs de GitHub Actions

### L'application ne démarre pas
- Vérifier les logs de l'application
- S'assurer que le port 8080 est bien exposé
- Vérifier la configuration mémoire dans app.yaml

## Ressources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Docker Documentation](https://docs.docker.com/)
- [Google Cloud Documentation](https://cloud.google.com/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)