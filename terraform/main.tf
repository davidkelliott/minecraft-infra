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
  region  = "us-west-2"
}

resource "aws_instance" "server" {
  ami                         = "ami-09a1e275e350acf38"
  instance_type               = "t3a.nano"
  key_name                    = "minecraft"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.minecraft.id]
  user_data                   = "${data.template_file.user_data.rendered}"

  tags {
    Name = "Minecraft Server"
  }
}

data "template_file" "user_data" {
  template = "${file("templates/user_data.tpl")}"
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft_sg"
  description = "Allow mincraft traffic"

  ingress {
    description = "Minecraft port"
    from_port   = 19132
    to_port     = 19132
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mincraft_sg"
  }
}