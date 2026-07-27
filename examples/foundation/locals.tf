locals {
  workload    = "platform"
  region_code = "use1"
  environment = "dev"

  inherited_tags = {
    Application = "landing-zone"
    Environment = "DEV"
    ManagedBy   = "Terraform"
    Owner       = "CCOE"
  }
}
