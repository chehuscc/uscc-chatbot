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

# The application's jar file
WORKDIR /app

# Copy the application's jar to the container
COPY --from=builder /usr/src/iotd/target/*.war app.war

# Make container port available to the world outside this container
EXPOSE 8080

# Run the jar file
ENTRYPOINT java -Djava.security.egd=file:/dev/./urandom -jar app.war


