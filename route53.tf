# resource "aws_route53_zone" "primary" {
#   name = "example.com"
# }

resource "aws_route53_record" "www" {
  zone_id = var.hosted_zone_id # uses an existing zone in my aws account
  name    = "mscodesdigitalsolutions.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
