# Use a maintained Java 21 runtime image
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
# Copy the JAR file from your local 'target' directory
COPY target/Todo-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8088  # CHANGÉ DE 8080 À 8088
ENTRYPOINT ["java", "-jar", "app.jar"]