data "aws_route53_zone" "mscodesdigitalsolution_com" {
  name         = "mscodesdigitalsolutions.com"
  private_zone = false
}

resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.mscodesdigitalsolution_com.zone_id
  name    = "mscodesdigitalsolutions.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.mscodesdigitalsolution_com.zone_id
  name    = "www.mscodesdigitalsolutions.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "mscodesdigitalsolutions.com"
  subject_alternative_names = ["www.mscodesdigitalsolutions.com"]
  validation_method         = "DNS"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.mscodesdigitalsolution_com.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.mscodesdigitalsolution_com.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
