FROM maven:3.5-jdk-8

LABEL version="0.1"

RUN mkdir -p /src/src/
COPY src/ /src/src
COPY pom.xml /src/

WORKDIR /src/

RUN mvn package

CMD ["java","-jar","/src/target/memento-0.1-jar-with-dependencies.jar"]
