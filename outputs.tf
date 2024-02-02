output "lb" {
  value = aws_lb.lb
}

output "http" {
  value = aws_lb_listener.http
}

output "https" {
  value = aws_lb_listener.https
}

output "security_group" {
  value = aws_security_group.app_lb
}
