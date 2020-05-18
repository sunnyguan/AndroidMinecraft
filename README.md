Made a post a while ago on r/Android about how to host a Minecraft server on an Android device. Here are some updates with clearer steps and steps for loading in your own worlds and mods!

Some basics:

1. No root required
2. Time required: about half an hour actively working, about an hour max downloading files
3. Result: works great on my OnePlus 6T (8GB RAM), no lag at all playing with friends with Forge

# Requirements:

1. Android phone that can run Termux and have at least 2-4GB of RAM
   1. For the initial testing, I used an OnePlus 6T with 8 GB of RAM (which ran very well). System RAM usage varied between 5.5GB and 6GB but the default is around 4GB so it wasn’t that surprising.
   2. I also tested using a Moto E2 while writing this guide to test out the installation of the Forge server. It was barely functioning with Forge and was barely playable since it only had 1GB memory.
   3. If your phone is decent, it should be able to run a vanilla server with no problem but YMMV.
2. Reliable internet connection
   1. Downloading a lot of stuff (at least 500MB)
3. Minecraft account
   1. Not strictly necessary just for starting a server, but if you want to test it out you should have one ready.

# Overall steps:

1. Get Termux to run a mini Ubuntu on your Android device
2. Use SSH to connect Termux to a Windows computer for easier copy+paste commands
3. Install OpenJDK 8 (Java)
4. Run Minecraft Server (or Forge)
5. Install ngrok
6. Connect local Minecraft server to ngrok servers
7. Copying over your worlds/mods
8. Common questions

# Step 1

1. Download Termux and AnLinux on your Android from Google Play Store
2. Select Ubuntu on AnLinux and copy the code
3. Run the command on Termux
4. To start the server, we would have to run `./start-ubuntu.sh`
   1. I personally renamed it to `s` by running this command `mv` [`start-ubuntu.sh`](https://start-ubuntu.sh) `s`
   2. This allows me to get into Ubuntu by running just `./s`
5. run `./s` to start the ubuntu machine
6. VERY IMPORTANT: Drag down on your notification bar, there should be an option to “Acquire Wakelock” for Termux. This allows it to not be killed by the system and continue running in the background.

# Step 2 (Optional SSH)

1. NOTE: Skip if you do not have a computer or if you are fine with typing in really long URLs
   1. Alternative: send yourself commands as messages on some messaging app and copying those commands to be run on Termux
2. (on Termux) installing ssh server `pkg install openssh` and `pkg install nmap`
3. (on Termux) Some things that we will use later:
   1. Run `whoami` to see our username (mine was u0\_a121)
   2. Run `ifconfig wlan0` to see your ip address (something starting with 192.168, remember to copy the first one, not the second one which isn’t your ip address)
   3. Run `passwd` to set a new password for your system (set it to something very easy to remember 12345678)
   4. Things to jot down: username, ip address, new password
4. download PuTTY (if you’re on Windows, skip if macOS) [https://www.chiark.greenend.org.uk/\~sgtatham/putty/latest.html](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
5. Connect as follows (on computer)
   1. Windows PuTTY: hostname is your IP address, port is 8022, connection type is SSH, click Open at the bottom without changing anything else
   2. Mac terminal: `ssh USERNAME@IPADDRESS -p 8022`
      1. For example, mine was `ssh u0\_a121@192.168.1.xxx \-p 8022`
6. (on computer) When prompted for username (on Windows), type your username from step 2.1
   1. Enter in your password from before as well
7. (on computer, you're free from typing on phone now!) run `./s` to get into your file system

# Step 3

1. `add-apt-repository ppa:openjdk-r/ppa`
2. `apt-get update`
3. `apt-get install openjdk-8-jre`
4. Test by running `java -version`
5. Make sure that it verifies that Java is installed (1.8)

# Step 4 (vanilla)

1. Make sure you’re at the home directory. Type `cd \~` to make sure.
2. Make a new folder for your minecraft directory `mkdir mc`, `cd mc` to go into the directory
3. Go to [https://www.minecraft.net/en-us/download/server/](https://www.minecraft.net/en-us/download/server/)
4. Right-click on the minecraft\_server link and copy link
5. `wget -O minecraft\_server.jar https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar`
   1. replace the https link with your own link if the version isn't 1.15.2
6. run `chmod +x minecraft\_server.jar`
7. run `java -Xmx1024M -Xms1024M -jar minecraft\_server.jar nogui` to start the server
   1. (Give more RAM if you have more; I set mine to 3 Gigabytes `-Xmx3G`)

# Step 4 (Forge)

1. Make sure you’re at the home directory after starting ubuntu. If not, type `cd \~`
2. `mkdir forge` to start a new directory, `cd forge` to go in
3. download forge server
   1. `wget` [`https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.15.1-30.0.51/forge-1.15.1-30.0.51-installer.jar`](https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.15.1-30.0.51/forge-1.15.1-30.0.51-installer.jar)
4. Rename it to make it easier
   1. `mv forge* forge.jar`
5. install server (it takes a while depending on your phone/wifi speed, took about half an hour on my Moto E2 and 8mbps wifi)
   1. `java -jar forge.jar --installServer`
6. run server, it will give you an error telling you to agree to eula.txt
   1. `java -Xms512M -Xmx1024M -jar forge-1.15.1-30.0.51.jar`
7. Open eula.txt by `nano eula.txt`, arrow down to the last line, delete false, replace with true
   1. Ctrl-x to exit, Y to save.
8. Rerun the previous command one eula.txt has been changed, it will take a while to generate a world
9. Rename the forge so it’s easier to start later
   1. `mv forge-1.15.1-30.0.51.jar startForge.jar`
10. `java -Xms1024M -Xmx3096M -jar startForge.jar`
11. (Note: adjust memory as needed, don’t give it 3G if your phone is a potato)

# Step 5

1. Go to [ngrok.com/download](https://ngrok.com/download)
2. Right-click and copy link for Linux (ARM64)
3. `wget -O` [`ngrok.zip`](https://ngrok.zip) [`https://bin.equinox.io/a/nmkK3DkqZEB/ngrok-2.2.8-linux-arm64.zip`](https://bin.equinox.io/a/nmkK3DkqZEB/ngrok-2.2.8-linux-arm64.zip`)
   1. replace the https link with your own link
4. `apt-get install zip unzip`
5. `unzip ngrok.zip`

# Step 6

1. Make an account at ngrok on their website
2. copy the auth token line given to you and run it
   1. should look something like this `./ngrok authtoken awefioauw4u0239840293j023jf0j23f23kj`
3. `./ngrok tcp 25565`
4. if a screen shows up with "Session Status online" in green, copy the address in forwarding after the tcp part
   1. >!Forwarding                            tcp://0.tcp.ngrok.io:12345!<
   2. copy the `0.tcp.ngrok.io:12345` section

# Step 7

1. Login to Minecraft, make sure the version is the latest version
2. Multiplayer, then direct connect and paste in the ngrok link from the end of Step 6
3. Connect!

# Use your own Worlds

1. Copy your worlds folder over from somewhere else into your phone
2. When connecting over usb, copy it over to your Download folder
3. back to termux
4. if you are in ubuntu (started ubuntu) already, type exit to get out into the default termux layer
5. Go to your Download folder cd /storage/emulated/0/Download
6. Copying world folder to Termux
   1. forge: `cp -r yourWorldFolderName /data/data/com.termux/files/home/ubuntu-fs/root/forge`
   2. vanilla: `cp -r yourWorldFolderName /data/data/com.termux/files/home/ubuntu-fs/root/mc`
7. `cd /data/data/com.termux/files/home/ubuntu-fs/root/forge`
8. `nano` [`server.properties`](https://server.properties)
9. find the line >!level-name=world!<
10. change >!world!<into whatever your folder name is called
11. Ctrl-x to exit, Y to save
12. Start server and ngrok

# Common questions

1. How do you start both the server AND ngrok? Don’t I have to stop one to start the other?
   1. On your Android, drag from the left side of your screen while you’re in termux. There should be a button for starting a new session. Once you’re in there, you can go into the ubuntu system first by `./s`, then start ngrok/server. To go back to the other session, drag on the left again and tap on the other session to start server/ngrok.
2. Can my phone run it?
   1. If it has at least 4GB of RAM and your WiFi is decent: Definitely
   2. If it has at least 2GB of RAM and your WiFi is decent: Maybe, maybe not
   3. If it has less than 2GB of RAM or your WiFi is very questionable: sorry : (
3. Do I really have to run the commands for ngrok and Minecraft server every time I want to play?
   1. Personally, I put the ngrok command in a file (named n) and the Minecraft command in another file (named m). After opening two sessions on Termux, I run ./n on one and ./m on the other. Here is the content of each file (I am running Forge so go back through the steps to see what your commands should be):
   2. File named “m” (no extension or anything):
      1. `cd forge`
      2. `java -Xms1G -Xmx3G -jar startForge.jar nogui`
   3. File named “n” (also no extension):
      1. `cd ngrok`
      2. `./ngrok tcp 25565`
   4. So now whenever I want to play Minecraft, I follow these steps:
      1. Open Termux
      2. `./s` to get into Ubuntu
      3. `./m` to start Minecraft server
      4. Swipe on left, open another session
      5. `./n` to start ngrok server
      6. Open Minecraft on my computer, copy over the link from ngrok, wait for the server to start, connect!
4. Why does this work?
   1. Termux allows your phone to have a mini-Linux machine. Linux machines can run Minecraft servers. Ngrok allows you to port-forward your local server port (25565) onto a public port where everyone can join (so please enable your whitelist so people don’t come in and destroy your worlds).
5. How do I use mods?
   1. Same procedure as copying over worlds. Except instead of copying it over as a world folder `forge/yourWorldName`, you copy it into the mods folder `forge/mods`. Make sure you have the same mods on your computer and it should be good to go.
6. Ngrok is telling me to update, will it break my server if I updated?
   1. I would recommend updating ngrok if it prompts you to. You just have to type `ctrl-u` and wait about a minute then restart ngrok. It won’t break anything as it’s just broadcasting your port.
7. My server is not working and it’s not because of bad WiFi or bad phone specs, what can I do?
   1. If none of the tips above helped and nobody in the comments had the same problem, you can send me a message but make sure to include a screenshot (if applicable) and a description of your issue.

# References:

Forge on Linux: [https://www.linuxnorth.org/minecraft/modded\_linux.html](https://www.linuxnorth.org/minecraft/modded_linux.html)

Please let me know if you have any questions and I will be happy to answer and update this post if needed!
