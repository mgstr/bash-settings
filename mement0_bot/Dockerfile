# Use an official java runtime as a base image
FROM openjdk:8u121-jdk

RUN mkdir shared

# Set the working directory to /shared
WORKDIR /shared

COPY target/memento-0.1-jar-with-dependencies.jar /shared

# Copy the current directory contents into the container at /shared
ADD . /shared

# Make port 80 available to the world outside this container
EXPOSE 80

# Run jar when the container launches
CMD ["java", "-jar" "memento-0.1-jar-with-dependencies.jar"]