resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = local.http_port

  default_action {
    target_group_arn = ""
    type             = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = local.https_port
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = local.https_port
  protocol          = "HTTPS"
  certificate_arn   = var.default_certificate_arn

  default_action {
    target_group_arn = ""
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = local.not_found_error
    }
  }
}

resource "aws_lb_listener_rule" "blocked" {
  for_each = toset(var.blocked_paths)

  action {
    target_group_arn = ""
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = local.not_found_error
    }
  }

  condition {
    path_pattern { values = [each.value] }
  }

  listener_arn = aws_lb_listener.https.arn
  priority     = var.blocked_priority
}
