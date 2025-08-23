resource "aws_ssm_parameter" "frontend_alb_listener_arn" { # arn means amazon resource name
  name  = "/${var.project}/${var.environment}/frontend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.frontend_alb.arn
}
