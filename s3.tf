resource "aws_s3_bucket" "s3_lb_logs_bucket" {
  bucket        = "unique-bucket-name-lb-logs"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.s3_lb_logs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_lb_logs_bucket.id

  rule {
    id = "rule-1"

    filter {
      object_size_greater_than = 200 # Object size values are in bytes
    }

    transition {
      days          = 10
      storage_class = "GLACIER_IR"
    }

    expiration {
      days = 30
    }

    status = "Enabled"
  }

  rule {
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    filter {}
    id     = "incomplete"
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.s3_lb_logs_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "erraform_bucket_public_access" {
  bucket = aws_s3_bucket.s3_lb_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_access_from_lb" {
  bucket = aws_s3_bucket.s3_lb_logs_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_lb.json
}

# Use the link below to get elb account ID for your region
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
data "aws_iam_policy_document" "allow_access_from_lb" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.s3_lb_logs_bucket.arn,
      "${aws_s3_bucket.s3_lb_logs_bucket.arn}/*",
    ]
  }
}
