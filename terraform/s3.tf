resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.bucket.id
    target_prefix = "log/"
  }
}
