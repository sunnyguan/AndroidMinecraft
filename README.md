# AndroidMinecraft

Android + Minecraft

# Requirements:

1. Android phone that can run Termux and have at least 4GB of RAM 

I used a OnePlus 6T with 8 GB of RAM. System RAM usage varied between 5.5GB and 6GB but that could just be my phone.

2. Reliable internet connection

Downloading a lot of stuff (at least 500MB)

3. Minecraft account

Not strictly necessarily just for starting a server, but if you want to test it out you should have one ready.

# Overall steps:

1. Get Termux to run a mini Ubuntu on your Android device

2. Use SSH to connect Termux to a Windows computer for easier copy+paste commands

3. Install OpenJDK 8

4. Run Minecraft Server

5. Install ngrok

6. Connect local minecraft server to ngrok servers

7. Done !

# Step 1

1. Download Termux and AnLinux on your Android

2. Select Ubuntu on AnLinux and copy the code

3. Run the command on Termux

4. run `./start-ubuntu.sh` to start the ubuntu machine

# Step 2

1. https://www.youtube.com/watch?v=RxZRmKv-F94

# Step 3

1. add-apt-repository ppa:openjdk-r/ppa

2. apt-get update

3. apt-get install openjdk-8-jre

4. Test by running `java -version`

# Step 4

1. Go to https://www.minecraft.net/en-us/download/server/

2. Right click on the minecraft_server link and copy link

3. `wget -O minecraft_server.jar https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar`

replace the https link with your own link if version isn't 1.14.4

4. run `chmod +x minecraft_server.jar`

5. run `java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui` to start the server

# Step 5

1. Go to ngrok.com/download

2. Right click and copy link for Linux (ARM64)

3. `wget -O ngrok.zip https://bin.equinox.io/a/nmkK3DkqZEB/ngrok-2.2.8-linux-arm64.zip`

replace the https link with your own link

4. `apt-get install zip unzip`

5. `unzip ngrok.zip`

# Step 6

1. Make an account at ngrok

2. copy the authtoken line given to you and run it

should look something like this `./ngrok authtoken awefioauw4u0239840293j023jf0j23f23kj`

3. `./ngrok tcp 25565`

4. if a screen shows up with "Session Status online" in green, copy the address in forwarding after the tcp part

    Forwarding                            tcp://10.tcp.ngrok.io:12345
    copy the `10.tcp.ngrok.io:12345` section

# Step 7

1. Login to Minecraft, make sure the version is the latest version (not snapshot)

2. Multiplayer, then direct connect and paste in the ngrok link from the end of Step 6

3. Connect !
