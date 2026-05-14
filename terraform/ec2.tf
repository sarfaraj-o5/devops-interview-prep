resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}


resource "aws_instance" "web" {
  count         = 3
  for_each      = toset(["dev", "prod"])
  ami           = "ami-12345"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.sub1.id
  depends_on    = [aws_security_group.sg]
  tags = {
    Name = "terraform-ec2"
  }
  lifecycle {
    ignore_changes = [tags]
  }
  lifecycle {
    prevent_destroy       = true
    create_before_destroy = true
    ignore_changes        = [tags]
  }

}
