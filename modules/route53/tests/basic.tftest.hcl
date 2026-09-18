mock_provider "aws" {}
run "public_zone_and_record" {
  command = plan
  variables {
    zone_name = "example.com"
    records = {
      www = {
        name    = "www"
        type    = "A"
        records = ["192.0.2.10"]
      }
    }

  }
  assert {
    condition     = aws_route53_zone.this.force_destroy == false
    error_message = "force_destroy must default to false."
  }
  assert {
    condition     = aws_route53_record.this["www"].ttl == 300
    error_message = "Records must use the secure operational TTL default."
  }
}
run "reject_private_zone_without_vpc" {
  command = plan
  variables {
    zone_name    = "internal.example.com"
    private_zone = true
  }
  expect_failures = [aws_route53_zone.this]
}
