# syntax=docker/dockerfile:1

# ---- Build stage: JDK 21 + Gradle 8.7 through the wrapper (as in the README) ----
FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace/app

COPY gradlew settings.gradle build.gradle ./
COPY gradle gradle
# Strip Windows line endings so the wrapper script runs on Linux
RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

COPY src src
# README commands: tests, then packaging
RUN ./gradlew clean test --no-daemon && ./gradlew bootWar --no-daemon

# ---- Runtime stage: JRE only ----
FROM eclipse-temurin:21-jre
RUN groupadd --system spring && useradd --system --gid spring spring
USER spring:spring

WORKDIR /app
COPY --from=build /workspace/app/build/libs/*.war app.war

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.war"]
