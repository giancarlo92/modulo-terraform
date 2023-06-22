provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "ssh_connection" {
  name = var.sg_name
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_instance" "platzi-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  tags          = var.tags
  security_groups = [aws_security_group.ssh_connection.name]
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      password = "gianKOKI10"
      private_key = file("~/.ssh/packer-key")
      host = self.public_ip
    }
    inline = [
      "echo hello",
      "sudo systemctl start docker",
      "docker run -d --name preventor-backend -p 80:80 g10n92/preventor-net7:latest"
    ]
  }
}