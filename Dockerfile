FROM resin/rpi-raspbian:latest
MAINTAINER Alex Jankuv <ajankuv@jedicloudsolutions.com>

RUN apt-get update && sudo apt-get upgrade -y
RUN apt-get install rpi-update && echo Y | sudo rpi-update

RUN echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | sudo tee -a /etc/apt/sources.list.d/ubnt.list > /dev/null \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 \
    && apt-get update \
    && apt-get install unifi -y

RUN echo 'ENABLE_MONGODB=no' | sudo tee -a /etc/mongodb.conf > /dev/null

#RUN cd /usr/lib/unifi/lib \
#    && rm snappy-java-1.0.5.jar \
#    && wget https://repo1.maven.org/maven2/org/xerial/snappy/snappy-java/1.1.4-M3/snappy-java-1.1.4-M3.jar \
#    && ln -s snappy-java-1.1.4-M3.jar snappy-java-1.0.5.jar

RUN apt-get install oracle-java8-jdk -y \
    && echo 'JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt' | sudo tee /etc/default/unifi > /dev/null

EXPOSE 8080 8443 8880 8843
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
