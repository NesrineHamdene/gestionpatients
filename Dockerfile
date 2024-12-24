# Utiliser l'image officielle de Java 17
FROM openjdk:17-jdk-slim AS build-stage

# Définir le répertoire de travail
WORKDIR /app

# Installer Maven
FROM maven:3.8.5-openjdk-17 AS final-stage


# Copier le fichier pom.xml dans l'image Docker
COPY pom.xml .

# Télécharger les dépendances Maven (cela crée le répertoire .m2)
RUN mvn dependency:go-offline

# Copier tout le code source dans le répertoire de travail
COPY src /app/src

# Compiler le projet avec Maven
RUN mvn clean package -DskipTests

# Étape finale: Utilisation d'une image de base plus légère
FROM openjdk:17-jdk-slim

# Définir le répertoire de travail dans l'image Docker
WORKDIR /app

# Copier le jar compilé de l'étape de build
COPY --from=build /app/target/gestionPatients-0.0.1-SNAPSHOT.jar /app/gestionPatients.jar

# Exposer le port sur lequel l'application Spring Boot sera exécutée
EXPOSE 8080

# Commande pour démarrer l'application
ENTRYPOINT ["java", "-jar", "/app/gestionPatients.jar"]
