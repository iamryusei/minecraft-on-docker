FROM ghcr.io/iamryusei/java-on-alpine-3.17:temurin-17-jre

RUN apk update

WORKDIR /opt/minecraft/

# create a dedicated user to run the container as
RUN adduser -D minecraft && \
    chown minecraft:minecraft /opt/minecraft/

# download and install the minecraft fabric server
RUN wget -O fabric-launcher.jar 'https://meta.fabricmc.net/v2/versions/loader/1.19.4/0.14.19/0.11.2/server/jar' &&\
    java -jar fabric-launcher.jar server -mcversion 1.17.1 -downloadMinecraft &&\
    echo 'eula=true' >> eula.txt

# download mods
RUN wget -O mods/fabric-api-0.78.0.jar 'https://mediafilez.forgecdn.net/files/4485/423/fabric-api-0.78.0%2B1.19.4.jar' &&\
    wget -O mods/lithium-0.11.1.jar 'https://cdn.modrinth.com/data/gvQqBUqZ/versions/14hWYkog/lithium-fabric-mc1.19.4-0.11.1.jar' &&\
    wget -O mods/phosphor-0.8.1.jar 'https://cdn.modrinth.com/data/hEOCdOgW/versions/mc1.19.x-0.8.1/phosphor-fabric-mc1.19.x-0.8.1.jar' &&\
    wget -O mods/ferrite-core-5.2.0.jar 'https://cdn.modrinth.com/data/uXXizFIs/versions/RbR7EG8T/ferritecore-5.2.0-fabric.jar'


# since the "/opt/minecraft/" directory can't be mounted as a volume, create symlinks that will point inside the "config/" directory
# which will be mounted as a volume instead.
RUN ln -s /opt/minecraft/config/server.properties /opt/minecraft/server.properties && \
    ln -s /opt/minecraft/config/ops.json /opt/minecraft/ops.json && \
    ln -s /opt/minecraft/config/whitelist.json /opt/minecraft/whitelist.json && \
    ln -s /opt/minecraft/config/banned-ips.json /opt/minecraft/banned-ips.json && \
    ln -s /opt/minecraft/config/banned-players.json /opt/minecraft/banned-players.json && \
    ln -s /opt/minecraft/config/usercache.json /opt/minecraft/usercache.json && \
    ln -s /opt/minecraft/config/server-icon.png /opt/minecraft/server-icon.png
    
# NoChatReports
RUN wget -O mods/nochatreports-2.1.1.jar 'https://cdn.modrinth.com/data/qQyHxfxd/versions/UB0mRick/NoChatReports-FABRIC-1.19.4-v2.1.1.jar'

# EasyAuth
RUN wget -O mods/easyauth-3.0.0-15.jar 'https://cdn.modrinth.com/data/aZj58GfX/versions/GWjihQlW/easyauth-mc1.19.4-3.0.0-15.jar'

RUN wget -O mods/fabrictailor-2.1.1.jar 'https://cdn.modrinth.com/data/g8w1NapE/versions/wKNEOjWL/fabrictailor-2.1.1.jar'

RUN wget -O mods/collective-6.54.jar 'https://mediafilez.forgecdn.net/files/4453/978/collective-1.19.4-6.54.jar' && \
    wget -O mods/justplayerheads-3.1.jar 'https://mediafilez.forgecdn.net/files/4439/177/justplayerheads-1.19.4-3.1.jar'

VOLUME /opt/minecraft/logs
VOLUME /opt/minecraft/world
VOLUME /opt/minecraft/config
VOLUME /opt/minecraft/mods/EasyAuth

EXPOSE 25565/tcp

CMD ["java", "-Xms2G", "-Xmx6G", "-jar", "fabric-launcher.jar", "nogui"]