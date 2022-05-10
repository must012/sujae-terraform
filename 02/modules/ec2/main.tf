data "aws_ami" "amazonLinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "ec2" {
  count         = var.ec2_count
  ami           = data.aws_ami.amazonLinux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    var.private_sg
  ]
  subnet_id = element(var.private_subnets, count.index)
  key_name  = "publicTestKey"

  root_block_device {
    volume_size = var.ebs
    volume_type = "gp3"
    tags = {
      "Name" = "${var.env}-private-ec2-${count.index + 1}-vloume-1"
    }
  }

  tags = {
    "Name" = "${var.env}-private-ec2-${count.index + 1}"
  }
}
