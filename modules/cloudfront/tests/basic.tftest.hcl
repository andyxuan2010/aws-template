mock_provider "aws" {}

run "private_s3_origin_and_https_behavior" {
  command = plan

  variables {
    name = "web-prod"
    origins = {
      app = { domain_name = "app.example.com" }
      assets = {
        domain_name = "assets.s3.us-east-1.amazonaws.com"
        s3          = true
      }
    }
    default_origin_id = "app"
    cache_policy_id   = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.default_cache_behavior[0].viewer_protocol_policy == "redirect-to-https"
    error_message = "Viewer requests must be redirected to HTTPS."
  }

  assert {
    condition     = aws_cloudfront_distribution.this.default_cache_behavior[0].target_origin_id == "app"
    error_message = "The default behavior must target the configured default origin."
  }

  assert {
    condition     = aws_cloudfront_origin_access_control.this["assets"].signing_behavior == "always"
    error_message = "S3 origins must use always-signing Origin Access Control."
  }
}

run "rejects_alias_without_certificate" {
  command = plan

  variables {
    name              = "web-prod"
    origins           = { app = { domain_name = "app.example.com" } }
    default_origin_id = "app"
    cache_policy_id   = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    aliases           = ["www.example.com"]
  }

  expect_failures = [aws_cloudfront_distribution.this]
}
