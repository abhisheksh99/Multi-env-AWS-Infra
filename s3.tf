resource "aws_s3_bucket" "my-bucket" {
    bucket = "tws-s3-bucket"
    tags = {
        Name = "tws-s3-bucket"

    }
  
}