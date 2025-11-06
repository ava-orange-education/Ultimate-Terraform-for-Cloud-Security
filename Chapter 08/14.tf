resource "google_security_center_notification_config" "example" {
  config_id   = "example-notification"
  description = "Notification for security alerts"
  pubsub_topic = "projects/my-project/topics/security-notifications"
  event_types = ["FINDING"]
}
