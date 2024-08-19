FROM openjdk:17-jdk-slim
COPY target/springboot-docker-demo-0.0.1-SNAPSHOT.jar /usr/app/
WORKDIR /usr/app
ENTRYPOINT [ "java", "-jar", "springboot-docker-demo-0.0.1-SNAPSHOT.jar"]
