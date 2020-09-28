terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.minecraft.id]
  user_data                   = templatefile(
    "${path.module}/templates/user_data.tpl",
    {
      server_name = var.server_name
      ipv4_port =var.ipv4_port
      ipv6_port = var.ipv6_port
      set_auto_start = var.set_auto_start
      backups = var.backups
    }
  )

  tags = {
    Name = var.server_name
  }
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft_sg"
  description = "Allow mincraft traffic"

  ingress {
    description = "Minecraft port"
    from_port   = var.ipv4_port 
    to_port     = var.ipv4_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_game_ips
  }

  ingress {
    description = "Minecraft port"
    from_port   = var.ipv4_port
    to_port     = var.ipv4_port
    protocol    = "udp"
    cidr_blocks = var.allowed_game_ips
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft_sg"
  }
}