# Étape 1 : Utiliser une image Maven pour construire l'application
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers du projet Maven
COPY pom.xml .
COPY src ./src

# Construire l'application en ignorant les tests
RUN mvn package -DskipTests

# Étape 2 : Utiliser une image OpenJDK plus légère pour exécuter l'application
FROM openjdk:17-jdk-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier JAR généré
COPY --from=build /app/target/gestionPatients-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Lancer l'application Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
