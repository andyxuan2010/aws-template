# Application Load Balancer module

Creates a hardened Application Load Balancer, target groups, health checks, and
forwarding listeners. It is internal, deletion-protected, HTTP/2-enabled, and
drops invalid header fields by default.

Internet-facing listeners must use HTTPS. Production requires access logs and
deletion protection. Listener rules beyond the default forwarding action should
be composed separately when applications need host- or path-based routing.
Target-group names include a stable hash of the logical map key so AWS's
32-character limit cannot collapse distinct keys into the same name.

```hcl
module "alb" {
  source = "../../modules/application_load_balancer"

  region_code       = "use1"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = values(module.vpc.private_subnet_ids)
  security_group_ids = [module.alb_sg.security_group_id]

  target_groups = {
    app = { port = 8080 }
  }

  listeners = {
    http = {
      port             = 80
      protocol         = "HTTP"
      target_group_key = "app"
    }
  }
}
```
