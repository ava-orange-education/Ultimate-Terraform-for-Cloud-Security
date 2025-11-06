resource "aws_cloudwatch_metric_alarm" "rollback_alarm" {
  alarm_name          = "rollback-on-error"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 90
  alarm_actions       = [aws_autoscaling_policy.rollback.arn]
}
