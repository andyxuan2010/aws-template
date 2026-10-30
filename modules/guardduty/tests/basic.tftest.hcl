mock_provider "aws" {}

run "foundational_detector_defaults" {
  command = plan

  variables {
    region_code = "use1"
  }

  assert {
    condition     = aws_guardduty_detector.this.enable
    error_message = "GuardDuty should be enabled by default."
  }

  assert {
    condition     = aws_guardduty_detector.this.finding_publishing_frequency == "SIX_HOURS"
    error_message = "Finding publishing frequency should default to six hours."
  }

  assert {
    condition     = aws_guardduty_detector.this.tags["Name"] == "gd-platform-use1-dev-001"
    error_message = "Detector Name tag does not follow the repository naming convention."
  }

  assert {
    condition     = length(aws_guardduty_detector_feature.this) == 0
    error_message = "Protection plan features should remain opt-in."
  }
}

run "configure_protection_features" {
  command = plan

  variables {
    region_code = "use1"
    features = {
      S3_DATA_EVENTS = {}
      RUNTIME_MONITORING = {
        additional_configuration = {
          EC2_AGENT_MANAGEMENT = "ENABLED"
        }
      }
    }
  }

  assert {
    condition     = aws_guardduty_detector_feature.this["S3_DATA_EVENTS"].status == "ENABLED"
    error_message = "Listed features should be enabled by default."
  }

  assert {
    condition     = contains([for configuration in aws_guardduty_detector_feature.this["RUNTIME_MONITORING"].additional_configuration : configuration.name], "EC2_AGENT_MANAGEMENT")
    error_message = "Runtime monitoring additional configuration was not passed through."
  }
}

run "reject_conflicting_runtime_features" {
  command = plan

  variables {
    region_code = "use1"
    features = {
      EKS_RUNTIME_MONITORING = {}
      RUNTIME_MONITORING     = {}
    }
  }

  expect_failures = [var.features]
}
