# Lambda function to alert unauthorized S3 access
resource "aws_lambda_function" "alert_lambda" {
  filename         = "alert_function.zip"            # Zip file containing your Lambda code
  function_name    = "S3UnauthorizedAccessAlert"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("alert_function.zip")
}

# CloudWatch Log Group (assuming S3 access logs are being delivered here)
resource "aws_cloudwatch_log_group" "s3_access_logs" {
  name = "/aws/s3/access-logs"
}

# Metric filter to detect unauthorized access events in S3 logs
resource "aws_cloudwatch_log_metric_filter" "unauthorized_filter" {
  name           = "UnauthorizedS3AccessFilter"
  log_group_name = aws_cloudwatch_log_group.s3_access_logs.name
  pattern        = "{ $.errorCode = \"AccessDenied\" }"

  metric_transformation {
    name      = "UnauthorizedS3Access"
    namespace = "Custom/S3"
    value     = "1"
  }
}

# CloudWatch Alarm to trigger the Lambda function upon unauthorized access detection
resource "aws_cloudwatch_metric_alarm" "unauthorized_access_alarm" {
  alarm_name          = "UnauthorizedS3AccessAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.unauthorized_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.unauthorized_filter.metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm when unauthorized S3 bucket access is detected."
  alarm_actions       = [aws_lambda_function.alert_lambda.arn]
}
