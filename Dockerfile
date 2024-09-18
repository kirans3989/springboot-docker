FROM openjdk:24-jdk-slim
COPY target/springboot-docker-demo-0.0.1-SNAPSHOT.jar /usr/app/
WORKDIR /usr/app
RUN apt-get update && apt-get install --only-upgrade bash dpkg apt
ENTRYPOINT [ "java", "-jar", "springboot-docker-demo-0.0.1-SNAPSHOT.jar"]
