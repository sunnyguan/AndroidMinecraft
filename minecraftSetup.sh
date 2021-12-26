#!/bin/bash

pkg install openjdk-17

##### USER CONFIGURATIONS #####

# set to true if you want to use forge, update FORGE_SERVER below to the correct version if necessary
# leave as false if using vanilla, update VANILLA_SERVER below if necessary
read -p "Using forge (yes/[no])? " USE_FORGE
USE_FORGE=${USE_FORGE:-no}

# set to false if you have your own port-forwarding setup
# leave as true to forward local ip to online through ngrok so other people can join
read -p "Using ngrok ([yes]/no)?" USE_NGROK
USE_NGROK=${USE_NGROK:-yes}

if [ "$USE_NGROK" = "yes" ] ; then
  read -p "ngrok authtoken (REQUIRED see https://dashboard.ngrok.com/get-started/your-authtoken): " AUTHTOKEN
  read -p "ngrok region ([us]/eu/ap/au/sa/jp/in): " NGROK_REGION
  NGROK_REGION=${NGROK_REGION:-us}
fi

# forge server URL (1.18.1), update as necessary
DEF_FORGE_INSTALLER="https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.1-39.0.8/forge-1.18.1-39.0.8-installer.jar"
DEF_VANILLA_SERVER="https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar"
if [ "$USE_FORGE" = "yes" ] ; then
  read -p "Custom Forge installer (leave blank for default: $DEF_FORGE_INSTALLER)? " FORGE_SERVER
  FORGE_SERVER=${FORGE_SERVER:-$DEF_FORGE_INSTALLER}
else
  read -p "Custom vanilla server (leave blank for default: $DEF_VANILLA_SERVER)? " VANILLA_SERVER
  VANILLA_SERVER=${VANILLA_SERVER:-$DEF_VANILLA_SERVER}
fi

# if you see an error about class version in the future, 
# check https://stackoverflow.com/questions/9170832/list-of-java-class-file-format-major-version-numbers
# and update this to the appropriate version
read -p "JRE Version (default is 17 for <=1.18)? " JDK_VERSION
JDK_VERSION=${JDK_VERSION:-17}

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
if [ "$USE_FORGE" = "yes" ] ; then
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
chmod +x ../m

# ngrok download and setup
if [ "$USE_NGROK" = "yes" ] ; then
  echo "STATUS: setting up ngrok"
  cd ..
  wget -O ngrok.tgz https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz && tar -xvzf ngrok.tgz
  echo "./ngrok tcp -region=$NGROK_REGION 25565" > n
  chmod +x n
  ./ngrok authtoken $AUTHTOKEN
fi


echo "STATUS: installation complete! Run ./m here to start minecraft server, open a new session by swiping on the left, and run ./n there to start ngrok"
