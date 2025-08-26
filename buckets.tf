locals {
  resolved_target_bucket = try(var.bucket_logging["target_bucket"], "")
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = var.bucket_force_destroy
  tags          = merge(var.tags)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key.id
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

resource "aws_s3_bucket_logging" "bucket" {
  bucket        = aws_s3_bucket.bucket.id
  target_bucket = local.resolved_target_bucket
  target_prefix = try(var.bucket_logging["target_prefix"], null)

  dynamic "target_object_key_format" {
    for_each = local.resolved_target_bucket != "" ? [var.bucket_logging["target_object_key_format"]] : []

    content {
      dynamic "partitioned_prefix" {
        for_each = target_object_key_format.value["partitioned_prefix"] != null ? [target_object_key_format.value["partitioned_prefix"]] : []

        content {
          partition_date_source = partitioned_prefix.value["partition_date_source"]
        }
      }

      dynamic "simple_prefix" {
        for_each = target_object_key_format.value["simple_prefix"] ? [true] : []

        content {}
      }
    }
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.bucket-acl-ownership]
}

resource "aws_s3_bucket_ownership_controls" "bucket-acl-ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = var.bucket_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "log"
    status = var.enable_logs_s3_sync && var.log_auto_clean ? "Enabled" : "Disabled"

    filter {
      prefix = "logs/"
    }

    transition {
      days          = var.log_standard_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.log_glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.log_expiry_days
    }
  }
}
