FROM openjdk:8-jdk-alpine
EXPOSE 8080
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG WAR_FILE=target/*.war
COPY ${WAR_FILE} app.war
ENTRYPOINT ["java","-war","/app.war"]
FROM tomcat:8.5.47-jdk8-openjdk
  
  COPY ./app.war /usr/local/tomcat/webapps
