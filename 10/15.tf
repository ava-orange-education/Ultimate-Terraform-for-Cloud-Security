resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example.com"
  type    = "A"
  alias {
    name                   = aws_elb.example.dns_name
    zone_id                = aws_elb.example.zone_id
    evaluate_target_health = true
  }
}
