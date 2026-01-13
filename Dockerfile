FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/todo-app.jar app.jar
EXPOSE 8088
ENTRYPOINT ["java", "-jar", "app.jar"]