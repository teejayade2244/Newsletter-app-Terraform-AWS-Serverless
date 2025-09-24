variable "stage" {
  description = "The deployment stage (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.stage)
    error_message = "Stage must be one of: dev, staging, prod."
  }
}

variable "jwt_secret" {
  description = "The secret key for signing JWTs"
  type        = string
  sensitive   = true
}

variable "lambda_source_dir" {
  description = "Path to Lambda function source code"
  type        = string
  default     = "../lambda"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "newsletter-api"
    ManagedBy   = "terraform"
    Environment = "var.stage"
  }
}
