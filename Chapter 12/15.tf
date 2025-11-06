# Default provider configuration for us-east-1
provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for us-west-2
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# CloudWatch alarm in us-east-1
resource "aws_cloudwatch_metric_alarm" "alarm_east" {
  alarm_name          = "example-alarm-east"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU utilization exceeds 80% in us-east-1"
  actions_enabled     = true
}

# CloudWatch alarm in us-west-2 using the aliased provider
resource "aws_cloudwatch_metric_alarm" "alarm_west" {
  provider            = aws.west
  alarm_name          = "example-alarm-west"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU utilization exceeds 80% in us-west-2"
  actions_enabled     = true
}
