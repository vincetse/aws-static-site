################################################################################
# S3 bucket
data "aws_iam_policy_document" "b_doc" {
  statement {
    sid = "PublicReadGetObject"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "*"
      ]
    }

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]

    effect = "Allow"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "${var.s3_bucket_name}"
  acl = "private"
  force_destroy = true
  policy = "${data.aws_iam_policy_document.b_doc.json}"

  website {
    index_document = "${var.index_doc}"
    error_document = "${var.error_doc}"
  }

  tags = {
    Terraform = true
  }
}

################################################################################
# Cloudfront
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "some comment"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.b.bucket_regional_domain_name}"
    origin_id   = "${var.s3_bucket_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

#  logging_config {
#    include_cookies = false
#    bucket          = "mylogs.s3.amazonaws.com"
#    prefix          = "myprefix"
#  }

  aliases = ["${var.domain_names}"]

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "${var.s3_bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 120
    viewer_protocol_policy = "redirect-to-https"

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = "${var.http_headers_arn}"
      include_body = false
    }
  }

  price_class = "${var.cloudfront_price_class}"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Terraform = true
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
