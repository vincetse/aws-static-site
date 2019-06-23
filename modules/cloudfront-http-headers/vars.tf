locals {
  lambda_zip = "${path.module}/functions.zip"
  input_filename = "${path.module}/http-headers.js"
  archive_filename = "http-headers.js"
  http_headers_handler = "http-headers.handler"
}

variable "http_headers_function" {
  type = "string"
  description = "Lambda function name"
  default = "cloudfront-http-headers"
}
