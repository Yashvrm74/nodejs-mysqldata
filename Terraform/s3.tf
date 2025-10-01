resource "aws_s3_bucket" "tf_s3_bucket1" {
  bucket = "nodejs-bucket100110100"

  tags = {
    Name        = "nodejs terraform bucket20252025"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "tf_s3_object" {
  bucket = aws_s3_bucket.tf_s3_bucket1.bucket
  for_each = fileset("../public/images", "**")
  key    = "images/${each.key}"
  source = "../public/images/${each.key}"
  
}