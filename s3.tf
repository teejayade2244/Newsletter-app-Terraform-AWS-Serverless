resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${local.resource_prefix}-lambda"
  tags   = var.common_tags
}

resource "aws_s3_bucket" "newsletter_media_bucket" {
  bucket = "${local.resource_prefix}-media"
  tags   = var.common_tags
}

resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_bucket_encryption" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "lambda_zip" {
  for_each = local.lambda_functions

  bucket = aws_s3_bucket.lambda_bucket.id
  key    = each.value.zip_key
  source = data.archive_file.lambda_zip[each.key].output_path
  etag   = filemd5(data.archive_file.lambda_zip[each.key].output_path)

  depends_on = [data.archive_file.lambda_zip]
}
