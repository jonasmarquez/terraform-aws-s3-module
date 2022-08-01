#------------------
# RESOURCE S3
#------------------
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name # IMPORTANT! Conflict with bucket_prefix
  bucket_prefix = var.bucket_prefix # IMPORTANT! Conflict with bucket

  # TAGs of Resources
  tags = var.tags
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket-acl" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls = var.ignore_public_acls
}