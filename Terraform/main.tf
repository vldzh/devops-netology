provider "aws" {
 region = "eu-west-1"
}

data "aws_ami" "ubuntu_server" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current_region" {}


resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu_server.id
  instance_type          = "t2.micro"
  tags                   = {
    Name  = "Test Server"
    Owner = "Vladislav Yezhergin"
  }

}