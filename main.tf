module "aws_utils" {
  source = "github.com/tfext/terraform-aws-base"
}

module "tagging" {
  source       = "github.com/tfext/terraform-utilities-tagging"
  environments = terraform.workspace != "default"
}

locals {
  logging                   = (var.logging != null) ? { logging = var.logging } : {}
  subnets                   = var.private ? var.vpc.private_subnet_ids : var.vpc.public_subnet_ids
  security_group_rule_count = var.manage_security_group_rules ? 1 : 0
  http_port                 = 80
  https_port                = 443
  not_found_error           = 404
}

resource "aws_lb" "lb" {
  name                 = var.name
  load_balancer_type   = "application"
  internal             = var.private || var.internal
  subnets              = local.subnets
  security_groups      = [aws_security_group.app_lb.id]
  preserve_host_header = true

  dynamic "access_logs" {
    for_each = local.logging
    iterator = config
    content {
      enabled = true
      bucket  = config.value["bucket"]
    }
  }
}
