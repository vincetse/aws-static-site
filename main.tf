provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
  profile = "cdn-admin"
}

locals {
  s3_bucket_name = "vt-cf-site"
}

module "http_headers" {
  source = "./modules/cloudfront-http-headers"
  http_headers_function = "cloudfront-http-headers"
}

module "site" {
  source = "./modules/cloudfront-s3-static-site"
  s3_bucket_name = "${local.s3_bucket_name}"
  http_headers_arn = "${module.http_headers.lambda_function_arn}"
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${local.s3_bucket_name}"
  key = "index.html"
  source = "index.html"
}
