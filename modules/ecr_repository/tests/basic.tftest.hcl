mock_provider "aws" {}

run "secure_defaults" {
  command = plan

  variables {
    region_code = "use1"
  }

  assert {
    condition     = aws_ecr_repository.this.image_tag_mutability == "IMMUTABLE"
    error_message = "Image tags must be immutable by default."
  }

  assert {
    condition     = aws_ecr_repository.this.image_scanning_configuration[0].scan_on_push
    error_message = "Image scanning must run on push."
  }
}

run "reject_mutable_production_repository" {
  command = plan

  variables {
    region_code          = "use1"
    environment          = "prod"
    image_tag_mutability = "MUTABLE"
  }

  expect_failures = [aws_ecr_repository.this]
}
