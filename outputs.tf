output "http_headers_arn" {
  value = "${module.http_headers.lambda_function_arn}"
}

output "site_domain_name" {
  value = "${module.site.cloudfront_domain_name}"
}
