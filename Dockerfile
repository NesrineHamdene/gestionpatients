# Étape de build: Utilisation de l'image Maven pour compiler l'application
FROM maven:3.8.5-openjdk-17 AS build-stage

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier pom.xml pour télécharger les dépendances Maven
COPY pom.xml ./

# Télécharger les dépendances Maven
RUN mvn dependency:go-offline

# Copier tout le code source
COPY src /app/src

# Compiler le projet et créer le fichier .jar
RUN mvn clean package -DskipTests

# Vérifier la présence du fichier .jar généré
RUN ls /app/target

# Étape finale: Utilisation d'une image Java plus légère
FROM openjdk:17-jdk-slim AS final-stage

# Définir le répertoire de travail dans l'image finale
WORKDIR /app

# Copier le fichier .jar depuis l'étape précédente
COPY --from=build-stage /app/target/gestionPatients-0.0.1-SNAPSHOT.jar /app/gestionPatients.jar

# Exposer le port de l'application
EXPOSE 8080

# Commande pour exécuter l'application
ENTRYPOINT ["java", "-jar", "/app/gestionPatients.jar"]
