module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "demo"
}
