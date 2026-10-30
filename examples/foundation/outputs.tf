output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "kms_key_arn" {
  value = module.kms.key_arn
}

output "iam_role_arn" {
  value = module.iam_role.role_arn
}
