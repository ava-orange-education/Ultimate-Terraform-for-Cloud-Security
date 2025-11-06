# Enable AWS GuardDuty
resource "aws_guardduty_detector" "main" {
  enable = true
}

# Create an SNS Topic for GuardDuty alerts
resource "aws_sns_topic" "guardduty_alerts" {
  name = "GuardDutyAlerts"
}

# Create a CloudWatch Event Rule to detect S3 data exfiltration findings
resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "GuardDuty-S3DataExfiltration"
  description = "Trigger when GuardDuty detects S3 data exfiltration attempts"
  event_pattern = <<EOF
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "GuardDuty Finding"
  ],
  "detail": {
    "type": [
      "UnauthorizedAccess:DataExfiltration.S3"
    ]
  }
}
EOF
}

# Set the SNS Topic as a target for the CloudWatch Event Rule
resource "aws_cloudwatch_event_target" "guardduty_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_findings.name
  target_id = "GuardDutySNSTarget"
  arn       = aws_sns_topic.guardduty_alerts.arn
}
