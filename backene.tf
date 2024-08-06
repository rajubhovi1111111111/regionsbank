terraform {
  backend "s3" {
    bucket         = "terraformtfstateregin"
    region         = "ap-south-1"
    key            = "env/dev/terraform.tfstate"
    encrypt = true

  }
}

resource "aws_s3_bucket" "terraform-backend-bucket" {
 bucket = "backend-bucket-iac-terraform"


 tags = {
   Name        = "tf-bucket"
   Environment = "dev"
 }
}
resource "aws_kms_key" "mykey" {
 description = "This key is used to encrypt bucket objects"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
 bucket = aws_s3_bucket.terraform-backend-bucket.id


 rule {
   apply_server_side_encryption_by_default {
     kms_master_key_id = aws_kms_key.mykey.arn
     sse_algorithm     = "aws:kms"
   }
 }
}


resource "aws_s3_bucket_versioning" "versioning_bucket_enabled" {
 bucket = aws_s3_bucket.terraform-backend-bucket.id
 versioning_configuration {
   status = "Enabled"
 }
}

