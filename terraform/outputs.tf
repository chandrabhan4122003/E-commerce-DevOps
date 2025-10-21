output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket
}

output "s3_bucket_website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website_distribution.id
}

output "cloudfront_distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website_distribution.domain_name
}

output "website_url" {
  description = "URL of the deployed website"
  value       = "https://${aws_cloudfront_distribution.website_distribution.domain_name}"
}

output "s3_website_url" {
  description = "Direct S3 website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}
