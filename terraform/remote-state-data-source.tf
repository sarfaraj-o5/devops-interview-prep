data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tf-state"
    key    = "vpc.tfstate"
    region = "ap-south-1"
  }
}
