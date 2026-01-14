# STAGE 1: Build (Sử dụng Image nặng chứa Maven)
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
# Copy file cấu hình trước để tận dụng cache của Docker
COPY pom.xml .
RUN mvn dependency:go-offline
# Copy toàn bộ code và build
COPY src ./src
RUN mvn clean package -DskipTests

# STAGE 2: Run (Sử dụng Image nhẹ chỉ chứa JRE)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Chỉ lấy file .jar đã build từ stage trước
COPY --from=build /app/target/*.jar app.jar
# Mở cổng 8080
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
