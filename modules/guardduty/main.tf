resource "aws_guardduty_detector" "this" {
  enable                       = var.enable
  finding_publishing_frequency = var.finding_publishing_frequency
  tags                         = local.detector_tags
}

resource "aws_guardduty_detector_feature" "this" {
  for_each = var.features

  detector_id = aws_guardduty_detector.this.id
  name        = each.key
  status      = each.value.status

  dynamic "additional_configuration" {
    for_each = each.value.additional_configuration

    content {
      name   = additional_configuration.key
      status = additional_configuration.value
    }
  }
}
