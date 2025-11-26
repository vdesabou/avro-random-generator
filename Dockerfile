# Build stage
FROM gradle:7.6-jdk8 AS builder

WORKDIR /app

# Copy gradle files first for better caching
COPY build.gradle settings.gradle gradlew ./
COPY gradle gradle/

# Copy source code
COPY src src/
COPY config config/

# Build the standalone JAR
RUN ./gradlew standalone

# Runtime stage
FROM eclipse-temurin:11-jdk

WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/bin/arg.jar /app/arg.jar

# Set the entrypoint to run the JAR
ENTRYPOINT ["java", "-jar", "/app/arg.jar"]
