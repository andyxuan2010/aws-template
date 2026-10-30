resource "aws_cloudfront_origin_access_control" "this" {
  for_each = { for key, origin in var.origins : key => origin if origin.s3

  }
  name                              = "${var.name}-${each.key}"
  description                       = "Private S3 origin access for ${var.name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  comment             = var.name
  default_root_object = var.default_root_object
  aliases             = var.aliases
  price_class         = var.price_class
  web_acl_id          = var.web_acl_id
  tags                = local.tags

  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.key
      origin_path              = origin.value.origin_path
      origin_access_control_id = origin.value.s3 ? aws_cloudfront_origin_access_control.this[origin.key].id : null
      dynamic "custom_origin_config" {
        for_each = origin.value.s3 ? [] : [origin.value]
        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols   = ["TLSv1.2"]

        }

      }

    }

  }

  default_cache_behavior {
    target_origin_id       = var.default_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    cache_policy_id        = var.cache_policy_id

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }

  }
  viewer_certificate {
    cloudfront_default_certificate = length(var.aliases) == 0
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = length(var.aliases) > 0 ? "sni-only" : null
    minimum_protocol_version       = length(var.aliases) > 0 ? "TLSv1.2_2021" : null

  }

  lifecycle {
    precondition {
      condition     = contains(keys(var.origins), var.default_origin_id)
      error_message = "default_origin_id must match a key in origins."

    }
    precondition {
      condition     = length(var.aliases) == 0 || var.acm_certificate_arn != null
      error_message = "Aliases require an ACM certificate ARN issued in us-east-1."

    }

  }
}
