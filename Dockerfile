# Start with a builder image containing Maven and JDK 1.8
FROM diamol/maven AS builder

WORKDIR /usr/src/iotd
COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY . .
RUN mvn package

# Start with a base image containing Java runtime
FROM openjdk:8-jdk-alpine

# Add Maintainer Info
LABEL maintainer="cheh.hoo@uscellular.com"

# Make container port available to the world outside this container
EXPOSE 8080

# The application's jar file
ARG JAR_FILE=./target/*.war

# Copy the application's jar to the container
COPY ${JAR_FILE} app.war

# Run the jar file
ENTRYPOINT java -Djava.security.egd=file:/dev/./urandom -jar app.war