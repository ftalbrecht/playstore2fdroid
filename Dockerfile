FROM ubuntu:16.04
MAINTAINER HeaDBanGer84

ENV RACCOON_VERSION 3.7

# Enable i386 arch
RUN dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get -y install software-properties-common \
  && add-apt-repository -y ppa:guardianproject/fdroidserver \
  && apt-get update
RUN  apt-get install -q -y  fdroidserver \
     default-jdk-headless
RUN rm -rf /var/lib/apt/lists/*

ADD cron.sh /bin/cron.sh
RUN chmod +x /bin/cron.sh
ADD raccoon-${RACCOON_VERSION}.jar /bin/raccoon.jar

VOLUME [/import.txt]
VOLUME [/raccoon]
VOLUME [/fdroid]

# Format:     m h    dom mon dow
#ENV CRONTIME="* */4   *   *   *"
ENV CRONTIME="* */10   *   *   *"
RUN echo "$CRONTIME  root	/bin/cron.sh >> /var/log/cron.log 2>&1" >> /etc/cron.d/play2fdroid-cron
#empty Line at the End of the crontab
RUN echo "" >> /etc/cron.d/play2fdroid-cron
RUN /usr/bin/crontab /etc/cron.d/play2fdroid-cron

WORKDIR /fdroid
CMD ["cron","-f"]
#CMD cron && tail -f /var/log/cron.log
#ENTRYPOINT ["cron","-f","&&","tail","-f","/var/log/output.log"]
