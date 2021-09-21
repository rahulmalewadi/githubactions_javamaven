FROM openjdk:8-jre-alpine

EXPOSE 8080

COPY ./build/libs/my-app-1.0-SNAPSHOT.war /usr/app/
WORKDIR /usr/app

ENTRYPOINT ["java", "-war", "my-app-1.0-SNAPSHOT.jar"]
