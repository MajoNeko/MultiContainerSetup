FROM eclipse-temurin:25-jdk

#Create a directory for the server
WORKDIR /app

# Copy the server jar from your local assets folder
COPY assets/server.jar /app/server.jar

#Accept the EULA
RUN echo "eula=true" > eula.txt

#Environment variables
ENV MEMORY=4G \
    PORT=25565 \
    WHITELIST=false \
    VIEW_DISTANCE=10 \
    MAX_PLAYERS=20 \
    MOTD="Don't Look Behind You Minecraft Server"

EXPOSE $APP_PORT

#Startup command ( TODO: should be moved to a script file)
#checks if the server.properties file exists and then applies our default variables
CMD ["sh", "-c", "\
  if [ ! -f server.properties ]; then \
    java -Xmx${MEMORY} -Xms${MEMORY} -jar server.jar nogui & \
    SERVER_PID=$!; \
    while [ ! -f server.properties ]; do sleep 1; done; \
    kill $SERVER_PID; \
  fi; \
  sed -i 's/white-list=.*/white-list=${WHITELIST}/' server.properties \
  sed -i 's/view-distance=10/view-distance=${VIEW_DISTANCE}/' server.properties; \
  sed -i 's/max-players=20/max-players=${MAX_PLAYERS}/' server.properties; \
  sed -i 's/motd=A Minecraft Server/motd=${MOTD}/' server.properties; \
  exec java -Xmx${MEMORY} -Xms${MEMORY} -jar server.jar nogui \
"]