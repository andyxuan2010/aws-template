resource "aws_acm_certificate" "this" {
  domain_name               = local.domain_name
  subject_alternative_names = sort(tolist(var.subject_alternative_names))
  validation_method         = upper(var.validation_method)
  key_algorithm             = var.key_algorithm
  tags                      = local.tags
  options {
    certificate_transparency_logging_preference = var.certificate_transparency_logging_preference
  }
  lifecycle {
    create_before_destroy = true
    precondition {
      condition     = !var.wait_for_validation || upper(var.validation_method) != "DNS" || var.hosted_zone_id != null
      error_message = "hosted_zone_id is required when waiting for DNS validation."

    }

  }
}
resource "aws_route53_record" "validation" {
  for_each        = local.validation_options
  zone_id         = var.hosted_zone_id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  records         = [each.value.resource_record_value]
  ttl             = var.validation_record_ttl
  allow_overwrite = true
}
resource "aws_acm_certificate_validation" "this" {
  count                   = var.wait_for_validation && upper(var.validation_method) == "DNS" ? 1 : 0
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
