FROM java:8

LABEL MAINTAINER="jack1902 <https://github.com/jack1902>"

## pull file redirected from https://www.curseforge.com/minecraft/modpacks/skyfactory-4/download/3012800/file
ARG URL="https://media.forgecdn.net/files/3012/800/SkyFactory-4_Server_4.2.2.zip"

RUN apt-get install -y wget unzip && \
 addgroup --gid 1234 minecraft && \
 adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft

RUN mkdir /tmp/feed-the-beast && cd /tmp/feed-the-beast && \
 wget -c ${URL} -O SkyFactory_4_Server.zip -q && \
 unzip SkyFactory_4_Server.zip -d /tmp/feed-the-beast && \
 chmod -R 777 /tmp/feed-the-beast && \
 chown -R minecraft /tmp/feed-the-beast && \
 cd /tmp/feed-the-beast && bash -x Install.sh && \
 chmod -R 777 /tmp/feed-the-beast && \
 chown -R minecraft /tmp/feed-the-beast

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER minecraft

VOLUME /data
ADD server.properties /tmp/server.properties
WORKDIR /data

EXPOSE 25565

CMD ["/start.sh"]

ENV MOTD "A Minecraft (SkyFactory 4.2.2) Server Powered by Docker"
ENV LEVEL world
ENV JVM_OPTS "-Xms2048m -Xmx2048m"
