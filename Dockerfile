FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY . .
RUN mkdir -p ./calculadora/db && \
    mvn -B flyway:migrate -Dflyway.configFiles=./flyway/flyway-pro.conf && \
    mvn -B clean package -DskipTests

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/api-regime-geral.jar app.jar
COPY --from=build /app/calculadora ./calculadora
ENV JAVA_OPTS="-Xmx384m"
CMD sh -c "java $JAVA_OPTS -Dspring.profiles.active=offline -jar app.jar --server.port=${PORT:-8080}"
