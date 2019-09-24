from ubuntu:16.04

MAINTAINER nerdjahn

ENV TOMCAT_VERSION 9.0.26
ENV JAVA_VERSION_UPDATE 221

# Set locales
RUN apt-get update && \
apt-get install -y locales && \
locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install net-tools
RUN apt-get install -y postgresql-client
RUN apt-get install -y netcat
RUN apt-get install -y vim

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

COPY environment /etc/

RUN mkdir /usr/lib/jvm

# Install JDK 8
COPY  jdk-8u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz /tmp/
RUN tar xzvf /tmp/jdk-8u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz -C /usr/lib/jvm 
RUN rm /tmp/jdk-8u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz


RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_${JAVA_VERSION_UPDATE}/bin/java 0
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_${JAVA_VERSION_UPDATE}/bin/javac 0
RUN update-alternatives --set java /usr/lib/jvm/jdk1.8.0_${JAVA_VERSION_UPDATE}/bin/java
RUN update-alternatives --set javac /usr/lib/jvm/jdk1.8.0_${JAVA_VERSION_UPDATE}/bin/javac

# Get Tomcat
RUN wget --quiet --no-cookies http://apache.rediris.es/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
rm /tmp/tomcat.tgz
# rm /tmp/tomcat.tgz && \
# rm -rf /opt/tomcat/webapps/examples && \
# rm -rf /opt/tomcat/webapps/docs && \
# rm -rf /opt/tomcat/webapps/ROOT

# Add admin/admin user
ADD tomcat-users.xml /opt/tomcat/conf/
ADD web.xml /opt/tomcat/webapps/manager/WEB-INF
ADD manager.xml /opt/tomcat/conf/Catalina/localhost/

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
# VOLUME "/opt/tomcat/webapps"
WORKDIR /opt/tomcat

# Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
