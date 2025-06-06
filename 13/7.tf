# Create a Route 53 Hosted Zone
resource "aws_route53_zone" "example" {
  name = "example.com"
}

# Configure the primary Route 53 record pointing to the primary ELB
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = aws_elb.primary.dns_name
    zone_id                = aws_elb.primary.zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "PRIMARY"
  }
}

# Configure the secondary Route 53 record pointing to the secondary ELB
resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = aws_elb.secondary.dns_name
    zone_id                = aws_elb.secondary.zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
}

# Primary ELB configuration in the primary region
resource "aws_elb" "primary" {
  name = "primary-elb"
  subnets = [var.primary_subnet]
  # Additional required configuration...
}

# Secondary ELB configuration in the secondary region
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

resource "aws_elb" "secondary" {
  provider = aws.secondary
  name     = "secondary-elb"
  subnets  = [var.secondary_subnet]
  # Additional required configuration...
}
