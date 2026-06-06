# Build stage
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY backend/pom.xml ./backend/
COPY backend/src ./backend/src
WORKDIR /app/backend
RUN mvn clean package -DskipTests

# Run stage
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/backend/target/backend-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 7860
ENTRYPOINT ["java", "-Dserver.port=7860", "-jar", "app.jar"]
