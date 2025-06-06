# Create a Pub/Sub Topic to forward logs to Chronicle
resource "google_pubsub_topic" "chronicle_topic" {
  name = "chronicle-topic"
}

# Create a Cloud Logging Sink that exports logs to the Pub/Sub Topic
resource "google_logging_project_sink" "chronicle_sink" {
  name        = "chronicle-sink"
  destination = "pubsub.googleapis.com/projects/${var.project_id}/topics/${google_pubsub_topic.chronicle_topic.name}"
  # Optionally, apply a filter to only export relevant logs
  filter      = "severity>=ERROR"
}
