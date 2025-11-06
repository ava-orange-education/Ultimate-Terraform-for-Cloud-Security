# Create a CloudWatch Log Metric Filter to detect IAM policy changes
resource "aws_cloudwatch_log_metric_filter" "iam_policy_changes" {
  name           = "IAMPolicyChanges"
  log_group_name = "/aws/cloudtrail/your-log-group"  # Replace with your actual CloudTrail log group name
  pattern        = "{ $.eventSource = \"iam.amazonaws.com\" && $.eventName =~ /^(Put|Delete|Create)/ }"

  metric_transformation {
    name      = "IAMPolicyChangesCount"
    namespace = "SecurityMetrics"
    value     = "1"
  }
}

# Create a CloudWatch Alarm that triggers when an IAM policy change is detected
resource "aws_cloudwatch_metric_alarm" "iam_policy_alarm" {
  alarm_name          = "IAMPolicyChangesAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.iam_policy_changes.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.iam_policy_changes.metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.alarm_action_arn]  # ARN of the SNS topic or other notification service to trigger alerts
}
