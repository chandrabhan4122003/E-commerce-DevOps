# S3 Website URL (Primary URL - much faster deployment)
output "website_url" {
  description = "S3 website URL (Primary - use this one)"
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket
}

output "s3_bucket_website_endpoint" {
  description = "S3 bucket website endpoint"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "s3_website_url" {
  description = "S3 website URL (Direct access)"
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}