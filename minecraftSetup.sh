#!/bin/bash

##### USER CONFIGURATIONS #####

# set to true if you want to use forge, update FORGE_SERVER below to the correct version if necessary
# leave as false if using vanilla, update VANILLA_SERVER below if necessary
USE_FORGE=false

# set to false if you have your own port-forwarding setup
# leave as true to forward local ip to online through ngrok so other people can join
USE_NGROK=true

# forge server URL (1.18.1), update as necessary
FORGE_SERVER="https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.1-39.0.8/forge-1.18.1-39.0.8-installer.jar"

# current version (1.18.1), update as necessary
VANILLA_SERVER="https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar"

# if you see an error about class version in the future, 
# check https://stackoverflow.com/questions/9170832/list-of-java-class-file-format-major-version-numbers
# and update this to the appropriate version
JDK_VERSION=17

# don't need to edit this
EXEC_SERVER_NAME="minecraft_server.jar"

##### MINECRAFT/NGROK INSTALLATION #####

# install openjdk
echo "STATUS: installing openjdk-${JDK_VERSION}" 
apt-get update
apt install software-properties-common -y
add-apt-repository ppa:openjdk-r/ppa -y
apt-get install openjdk-$JDK_VERSION-jre-headless zip unzip -y

# minecraft server download and setup
echo "STATUS: setting up Minecraft Server"
mkdir mc
cd mc
echo "eula=true" > eula.txt
if [ "$USE_FORGE" = true ] ; then
  wget $FORGE_SERVER
  installer_jar=$(echo $FORGE_SERVER | rev | cut -d '/' -f 1 | rev)
  exec_jar=$(echo $installer_jar | sed -e 's/-installer//g')
  java -jar $installer_jar --installServer
  mv $exec_jar $EXEC_SERVER_NAME
  rm $installer_jar
  echo "cd mc && ./run.sh" > ../m
else
  wget -O $EXEC_SERVER_NAME $VANILLA_SERVER
  echo "cd mc && java -Xmx1G -jar ${EXEC_SERVER_NAME} nogui" > ../m
fi
chmod +x m

# ngrok download and setup
if [ "$USE_NGROK" = true ] ; then
  echo "STATUS: setting up ngrok"
  cd ..
  wget -O ngrok.tgz https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz && tar -xvzf ngrok.tgz
  echo "./ngrok tcp 25565" > n
  chmod +x n
  echo "NOTE: Please go to ngrok.com, login/signup, and run the authtoken command to authorize ngrok locally"
  echo "      It should look something like ./ngrok authtoken 7FJB7s9O03jF..."
fi


echo "STATUS: installation complete! Run ./m here to start minecraft server, open a new session by swiping on the left, and run ./n there to start ngrok"
