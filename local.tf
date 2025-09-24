locals {
  resource_prefix = "newsletter-${var.stage}"
  
  lambda_functions = {
    auth = {
      handler     = "auth-handler.handler"
      zip_key     = "auth-handler.zip"
      description = "Authentication handler"
      environment = {
        USERS_TABLE = aws_dynamodb_table.users_table.name
        JWT_SECRET  = var.jwt_secret
      }
    }
    newsletter = {
      handler     = "newsletter-handler.handler"
      zip_key     = "newsletter-handler.zip"
      description = "Newsletter CRUD handler"
      environment = {
        NEWSLETTERS_TABLE = aws_dynamodb_table.newsletters_table.name
        S3_BUCKET         = aws_s3_bucket.newsletter_media_bucket.id
      }
    }
    authorizer = {
      handler     = "authorizer.handler"
      zip_key     = "authorizer.zip"
      description = "JWT authorizer"
      environment = {
        JWT_SECRET = var.jwt_secret
      }
    }
  }
}
