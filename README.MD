# Minecraft Server on EC2

Bare bones set up to get Minecraft running on an EC2 using the install scripts here:
https://github.com/TheRemote/MinecraftBedrockServer

## Setup

Set the variables as you wish, ensure you have the AWS CLI configured with an access key and have created a private key to use to SSH into the EC2. I highly recommend you change the allowed ips to your own home IP address, at the very least for the allowed_ssh_ips variable.

Run the Terraform and then SSH into the server to configure the usual Mincraft server.properties, whitelist, ops etc. 

Attach to the Minecraft console with:

`screen -d -r servername`

See Minecraft server guidance for console commands.

To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D.

If you are going to be turning your instance on and off you may want to attach an elastic IP to it, or set up Dynamic DNS. NoIP2 has been tested and works well.

Register account:

https://www.noip.com/sign-up

Install Linux client:

https://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/

## Connect to your server

Log on to Minecraft and add a new server, enter your EC2s public IP or DNS and port.
