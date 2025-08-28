resource "aws_acm_certificate" "shamrobos" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    }
  )
  lifecycle {
    create_before_destroy = true # This tells Terraform: When replacing a resource, always create the new one before destroying the old one.
  }
}

resource "aws_route53_record" "shamrobos" {
  for_each = {
    for dvo in aws_acm_certificate.shamrobos.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}


resource "aws_acm_certificate_validation" "shamrobos" {
  certificate_arn         = aws_acm_certificate.shamrobos.arn
  validation_record_fqdns = [for record in aws_route53_record.shamrobos : record.fqdn]
}