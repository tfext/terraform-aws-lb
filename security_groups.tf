resource "aws_security_group" "app_lb" {
  name   = "${var.name}-lb"
  vpc_id = var.vpc.id
  tags   = { Name = "${var.name}-lb" }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "https" {
  count             = local.security_group_rule_count
  security_group_id = aws_security_group.app_lb.id
  type              = "ingress"
  from_port         = local.https_port
  to_port           = local.https_port
  protocol          = "tcp"
  cidr_blocks       = [module.aws_utils.cidr_block_world]
  description       = "HTTPS (${module.tagging.managed_by})"
}

resource "aws_security_group_rule" "http" {
  count             = local.security_group_rule_count
  security_group_id = aws_security_group.app_lb.id
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = "tcp"
  cidr_blocks       = [module.aws_utils.cidr_block_world]
  description       = "HTTP (${module.tagging.managed_by})"
}

resource "aws_security_group_rule" "outbound" {
  security_group_id = aws_security_group.app_lb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [module.aws_utils.cidr_block_world]
  description       = "Outbound (${module.tagging.managed_by})"
}
