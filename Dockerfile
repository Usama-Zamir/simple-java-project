# Stage 1: Build the WAR
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run with Jetty Runner
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy WAR and jetty-runner.jar from build stage
COPY --from=build /app/target/works-with-heroku-1.0.war app.war
COPY --from=build /app/target/dependency/jetty-runner.jar jetty-runner.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "jetty-runner.jar", "app.war"]