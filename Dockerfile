# Use an official Maven image to build the application
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Use a smaller image to run the application
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=build /app/target/gestionPatients-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
