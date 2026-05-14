locals {
  common_tags = {
    Environment = "dev"
    Owner       = "xyz"
  }
}

tags = local.common_tags
