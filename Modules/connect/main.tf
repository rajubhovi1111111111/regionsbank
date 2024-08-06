resource "aws_connect_instance" "regionsbank" {
  identity_management_type = var.identity_management_type
  inbound_calls_enabled    = var.inbound_calls_enabled
  outbound_calls_enabled   = var.outbound_calls_enabled
  instance_alias           = var.instance_alias
  contact_flow_logs_enabled = true  
 
}


//s3

resource "aws_s3_bucket" "storage" {
  bucket = "connectstorageregionsbank"
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket                  = aws_s3_bucket.aws_s3_bucket_public_access_block.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_connect_instance_storage_config" "chat" {
  instance_id   = aws_connect_instance.regionsbank.id
  resource_type = "CHAT_TRANSCRIPTS"

  storage_config {
    s3_config {
      bucket_name   = aws_s3_bucket.storage.id
      bucket_prefix = "ChatTranscripts"
    }
    storage_type = "S3"
  }
}

resource "aws_connect_instance_storage_config" "chat" {
  instance_id   = aws_connect_instance.regionsbank.id
  resource_type = "CALL_RECORDINGS"

  storage_config {
    s3_config {
      bucket_name   = aws_s3_bucket.storage.id
      bucket_prefix = "CallRecording"
    }
    storage_type = "S3"
  }
}

resource "aws_connect_instance_storage_config" "chat" {
  instance_id   = aws_connect_instance.regionsbank.id
  resource_type = "SCHEDULED_REPORTS"

  storage_config {
    s3_config {
      bucket_name   = aws_s3_bucket.storage.id
      bucket_prefix = "ScheduledReports"
    }
    storage_type = "S3"
  }
}

resource "aws_iam_policy" "connect_policy" {
  name = "connect-s3-full-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetBucketLocation"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::connectstorageregionsbank",        // Bucket ARN
          "arn:aws:s3:::connectstorageregionsbank/*"       // Object ARN
        ]
      }
    ]
  })
}


resource "aws_iam_role" "connect_role" {
  name = "connect-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "connect.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "connect_role_attachment" {
  role       = aws_iam_role.connect_role.name
  policy_arn = aws_iam_policy.connect_policy.arn
}