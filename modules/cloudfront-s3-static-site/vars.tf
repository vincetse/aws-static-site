variable "s3_bucket_name" {
  type = "string"
  description = "S3 bucket name to create"
}

variable "error_doc" {
  type = "string"
  description = "Name of error doc for s3 static site"
  default = "error.html"
}

variable "index_doc" {
  type = "string"
  description = "Name of index doc for s3 static site"
  default = "index.html"
}

variable "cloudfront_price_class" {
  type = "string"
  description = <<END
Cloudfront price class, One of PriceClass_All, PriceClass_200, PriceClass_100.

See https://aws.amazon.com/cloudfront/pricing/
END
  default = "PriceClass_100"
}

variable "http_headers_arn" {
  type = "string"
  description = "ARN of Lambda function to add HTTP headers"
}

variable "domain_names" {
  type = "list"
  description = "List of domain aliases for Cloudfront CDN"
  default = []
}
