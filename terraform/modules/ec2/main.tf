resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg.id]
  key_name = var.key_name

  tags = merge(
    var.common_tags
  {
    Name = var.instance_name
  }
  )
}