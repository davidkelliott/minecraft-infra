#!/bin/bash
apt-get update
apt-get install expect -y
wget https://raw.githubusercontent.com/TheRemote/MinecraftBedrockServer/master/SetupMinecraft.sh
chmod +x SetupMinecraft.sh
./SetupMinecraft.sh
