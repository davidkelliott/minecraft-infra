variable "region" {
  default = "eu-west-2"
}

variable "ami" {
  default = "ami-09a1e275e350acf38"
}

variable "instance_type" {
  default = "t3a.micro"
}

variable "key_name" {
  default = "minecraft"
}

variable "server_name" {
  default = "MinecraftServer"
}

variable "ipv4_port" {
  default = 19132
}

variable "ipv6_port" {
  default = 19133
}

variable "set_auto_start" {
  default = "y"
  description = "Automatically start the server on EC2 startup (y/n)"
}

variable "backups" {
  default = "y"
  description = "Automatically restart and backup server at 4am daily (y/n)"
}

variable "allowed_ssh_ips" {
  default = ["0.0.0.0/0"]
}

variable "allowed_game_ips" {
  default = ["0.0.0.0/0"]
}
