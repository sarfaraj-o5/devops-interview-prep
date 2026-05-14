module "frontend" {
  source        = "./modules/ec2"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  sg_id         = aws_security_group.web_sg.id
  key_name      = "tf-key"
  instance_name = "frontend-ec2"
  common_tags   = local.common_tags
}
