FROM ubuntu:16.04
MAINTAINER HeaDBanGer84

ENV RACCOON_VERSION 3.7
ENV GOCRON_VERSION 0.0.2

# Install Dependecies and binaries for fdroid & raccoon
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get -y install software-properties-common \
  && add-apt-repository -y ppa:guardianproject/fdroidserver \
  && apt-get update \
  && apt-get install -q -y  fdroidserver \
     default-jdk-headless \
     wget \
  && rm -rf /var/lib/apt/lists/*

#Install raccoon
ADD raccoon-${RACCOON_VERSION}.jar /bin/raccoon.jar

# Install go-cron
# https://github.com/michaloo/go-cron
RUN wget "https://github.com/michaloo/go-cron/releases/download/v$GOCRON_VERSION/go-cron.tar.gz" -O "/tmp/go-cron.tar.gz" && \
   tar -xf /tmp/go-cron.tar.gz -C /usr/bin/ go-cron && \
   rm /tmp/go-cron.tar.gz

ADD cron.sh /bin/cron.sh
RUN chmod +x /bin/cron.sh

VOLUME [/import.txt]
VOLUME [/raccoon]
VOLUME [/fdroid]

# Format:     m h    dom mon dow
ENV CRONTIME="* */4   *   *   *"

WORKDIR /fdroid

CMD go-cron "$CRONTIME" /bin/bash -c "/bin/cron.sh"
