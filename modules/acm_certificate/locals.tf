locals {
  domain_name = lower(trimsuffix(var.domain_name, "."))
  tags = merge(var.inherited_tags, var.tags, {
    Name = local.domain_name
  })
  validation_options = var.hosted_zone_id == null ? {} : {
    for option in aws_acm_certificate.this.domain_validation_options : option.domain_name => option

  }
}
