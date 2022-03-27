#------------------
# AWS RESOURCE S3
#------------------
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket_name # IMPORTANT! Conflict with bucket_prefix
  #bucket_prefix = var.bucket_prefix # IMPORTANT! Conflict with bucket
  acl = "private"
   # Versioning Configuration
   versioning {
    enabled = var.versioning
  }

  # Encryption Configuracion for S3 Bucket (needs KMS Key)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_master_key_id
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  # TAGs of Resources
  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3-bucket-acl" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
  restrict_public_buckets = true
  ignore_public_acls = true
}
