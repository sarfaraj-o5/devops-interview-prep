module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "dev-eks"
  vpc_id       = aws_vpc.main.id
  subnet_ids   = [aws_subnet.public1.id, aws_subnet.public2.id]
}
