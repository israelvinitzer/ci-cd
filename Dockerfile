FROM maven:3.9.0-eclipse-temurin-17 as build

WORKDIR /app

COPY . .

RUN mvn clean install

FROM eclipse-eclipse-temurin:17.0.6_10-jdk

WORKDIR /app

COPY --from=build /app/target/demoapp.jar /apps/

EXPOSE 8080

cmd["java","-jar",demoapp.jar]