1. Download latest Oracle JDK 8 from the official website and
put in the tomcat9-oracle-jdk8 directory.

2. Update in the Dockerfile the JAVA_VERSION_UPDATE and TOMCAT_VERSION correspondingly.

3. Build the docker image using:
    
    docker build -t "tomcat9-oracle-jdk8" .
