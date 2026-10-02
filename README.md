# Workshop Organizer Web API

Welcome to the Workshop Organizer Web API! This application is designed to facilitate workshops open to the public. Whether you’re organizing coding bootcamps, art classes, or any other type of workshop, this API will help manage registrations, schedules, and resources.

## Table of Contents

1. Context
2. Technical Overview
3. Building and Running
4. Testing
5. Packaging
6. Publishing to GitLab Registry

## Context

Workshops play a crucial role in fostering learning and collaboration. Our application aims to streamline the workshop organization process, making it easier for organizers to manage participants, sessions, and materials. Whether you're a seasoned workshop host or just starting out, this API has got you covered!

## Technical Overview

- **Java Development Kit (JDK):** We use **JDK 21**, tested with **Adoptium**, to power our application.
- **Database:** Our backend relies on a **PostgreSQL 13** database for data storage.
- **Build Tool:** We leverage **Gradle 8.7** for managing dependencies and building the project.
- **Spring Boot:** Our application is based on **Spring Boot 3.2.4**, which provides a robust framework for creating RESTful APIs.
- **Application Server:** Our application can run on Tomcat server that require version 10.1.24.

## Building and Running

To compile and run the application locally, follow these steps:

1. Ensure you have JDK 21 installed.
2. Clone this repository.
3. Navigate to the project root directory and create your environment file from the template (see [Configuration](#configuration)):
   ```bash
   cp .env.example .env
   ```
4. Execute the following command to compile the Java code :
   ```bash
   ./gradlew clean compileJava
   ```
5. The application needs a PostgreSQL database to connect to. If you're running the app directly (via your IDE or `./gradlew bootRun`), Gradle does not start it for you. The `db` service in the compose file intentionally does not expose port 5432 outside the container cluster, so for local development start a standalone Postgres container instead, with the port published on your machine:
   ```bash
   docker run -d --name workshop-organizer-db -p 5432:5432 --env-file .env postgres:13
   ```
6. To run the application locally, either:
   Execute the main method in the Application class from your IDE.
   Use the Spring Boot Gradle Plugin :
   ```bash
   ./gradlew bootRun
   ```
   For production, package the application as WAR and use a tomcat server

To run correctly the application with docker (both the app and its database), create the `.env` file (see [Configuration](#configuration)), build the image with tag workshop-organizer, then start the stack:

```bash
docker build -t workshop-organizer .
docker compose up -d
```

The API is then available on http://localhost:8080. PostgreSQL data is kept in the `db-data` volume, and the application waits for the database health check before starting.

## Configuration

Database credentials are defined in a `.env` file at the project root (not versioned). Copy the template and adjust the values:

```bash
cp .env.example .env
```

- POSTGRES_DB: Database name
- POSTGRES_USER: Database user name
- POSTGRES_PASSWORD: Database user password

`docker compose` and the application (when run locally) both read this file.

You can also override the datasource with these environment variables (the compose file sets them from the `.env` values)

- SPRING_DATASOURCE_URL: JDBC URI for DB access (ex. jdbc:postgresql://db:5432/mydatabase)
- SPRING_DATASOURCE_USERNAME: Database user name used by the application
- SPRING_DATASOURCE_PASSWORD: Database user password used by the application

## Testing

We take testing seriously! To verify the correctness of our application, run the following command:

```bash
./gradlew clean test
```

During execution junit reports are generated in the `build/test-results/test` folder.

## Packaging

When you’re ready to package the application for deployment, create a deployable WAR file:

```bash
./gradlew bootWar
```

The generated war file can be used with many application servers such as Tomcat, Wildfly...

## Publishing to GitLab Registry

To publish your application to a GitLab registry, follow these steps:

1. Set up your GitLab project.
2. Ensure you have the following environment variables configured:

   - GITLAB_PROJECT_ID: The ID of your GitLab project.
   - GITLAB_TOKEN_NAME: The name of the GitLab access token.
   - GITLAB_TOKEN: Your GitLab access token.

3. Execute the following command to publish your application:
   ```bash
   ./gradlew publish
   ```
   Remember to replace placeholders with actual values specific to your project.

Feel free to enhance this README with additional details, such as API endpoints, security considerations, and deployment instructions. Happy organizing! 🚀
