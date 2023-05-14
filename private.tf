// private instance creation 

resource "aws_instance" "private_instance" {
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t2.nano"
  subnet_id     = aws_subnet.private_subnet1.id

  key_name = "test3"
  monitoring =true
  vpc_security_group_ids = [aws_security_group.bastionsec.id]
 

  tags = {
    Name = "private_subnet"
  }
}