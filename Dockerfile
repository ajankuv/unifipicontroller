FROM resin/rpi-raspbian:latest
MAINTAINER Alex Jankuv <ajankuv@jedicloudsolutions.com>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && sudo apt-get upgrade -y
#RUN apt-get install rpi-update && echo Y | sudo rpi-update

RUN echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | sudo tee -a /etc/apt/sources.list.d/ubnt.list > /dev/null \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 \
    && apt-get update \
    && apt-get install unifi -y

RUN echo 'ENABLE_MONGODB=no' | sudo tee -a /etc/mongodb.conf > /dev/null

RUN apt-get install oracle-java8-jdk -y \
    && echo 'JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt' | sudo tee /etc/default/unifi > /dev/null

RUN mkdir -p /opt/unifi/data \
    && ln - s /usr/lib/unifi /opt/unifi/data

EXPOSE 8080/tcp 8443/tcp 8880/tcp 8843/tcp

WORKDIR /var/lib/unifi
ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/opt/unifi/data/lib/ace.jar"]
CMD ["start"]
