# RDS module

Creates an encrypted RDS instance and DB subnet group. RDS manages the master
password in Secrets Manager; the module intentionally accepts no plaintext
password input.

Secure defaults use private networking, Multi-AZ, 35-day backups, deletion
protection, automated minor upgrades, tag-copying, and a final snapshot.
Production cannot weaken those controls.

```hcl
module "database" {
  source = "../../modules/rds"

  engine                 = "postgres"
  engine_version         = "16.4"
  instance_class         = "db.t4g.small"
  master_username        = "platform_admin"
  region_code            = "use1"
  subnet_ids             = values(module.vpc.private_subnet_ids)
  vpc_security_group_ids = [module.database_sg.security_group_id]
  kms_key_id             = module.kms.key_arn
}
```

Engine versions, log export names, and instance-class capabilities vary by
region. Root compositions must pin combinations validated for their target
region.
