data "aws_ami" "amazonLinux" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-2.0.*" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_instance" "testEC201" {
  ami = data.aws_ami.amazonLinux.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [ 
    aws_security_group.privateEC2SG01.id
   ]
  subnet_id = aws_subnet.privateEC2Subnet1.id
  key_name = "publicTestKey"
  
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    tags = {
      "Name" = "test-private-ec2-01-vloume-1"
    }
  }

  tags = {
    "Name" = "test-private-ec2-01"
  }
}

resource "aws_instance" "testEC202" {
  ami = data.aws_ami.amazonLinux.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [ 
    aws_security_group.privateEC2SG01.id
   ]
  subnet_id = aws_subnet.privateEC2Subnet2.id
  key_name = "publicTestKey"
  
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    tags = {
      "Name" = "test-private-ec2-02-vloume-1"
    }
  }

  tags = {
    "Name" = "test-private-ec2-02"
  }
}