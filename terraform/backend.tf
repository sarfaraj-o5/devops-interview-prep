terraform {
  backend "s3" {
    bucket       = "my-tf-state"
    key          = "prod/terrafrom.state"
    region       = "us-east-1"
    use_lockfile = true
  }
}
