resource "google_pubsub_topic" "scc_alerts" {
  name = "scc-alerts"
}

resource "google_pubsub_subscription" "scc_alerts_sub" {
  name  = "scc-alerts-sub"
  topic = google_pubsub_topic.scc_alerts.id
  push_config {
    # This push endpoint should be your AWS API Gateway endpoint that triggers a Lambda function in AWS.
    push_endpoint = "https://<aws-api-gateway-endpoint>/scc-alerts"
  }
}
