#!/bin/bash
apt-get update
apt-get install expect -y
cd /home/ubuntu
wget https://raw.githubusercontent.com/TheRemote/MinecraftBedrockServer/master/SetupMinecraft.sh
chmod +x SetupMinecraft.sh
wget https://raw.githubusercontent.com/davidkelliott/minecraft-infra/master/terraform/scripts/run_install.exp
chmod +x run_install.exp
/bin/su -c "/home/ubuntu/run_install.exp ${server_name} ${ipv4_port} ${ipv6_port} ${set_auto_start} ${backups}" - ubuntu
