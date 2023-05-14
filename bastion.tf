// selection of ami 

data "aws_ami" "amazonlinux2" {
owners      = ["amazon"]
most_recent = true

  filter {
      name   = "name"
      values = ["amzn2-ami-hvm*"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}

// security group creation


resource "aws_security_group" "bastionsec" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }


  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastionsec"
  }
}


// bastion server setup

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t2.nano"
  subnet_id     = aws_subnet.public_subnet1.id
  key_name = "test3"
  monitoring =true
  vpc_security_group_ids = [aws_security_group.bastionsec.id]
  iam_instance_profile = aws_iam_instance_profile.demo-profile.name
 

  tags = {
    Name = "bastion-server"
  }
}


