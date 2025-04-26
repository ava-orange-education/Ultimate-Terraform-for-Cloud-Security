variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "members" {
  description = "List of members to bind the role to."
  type        = list(string)
}

variable "conditions" {
  description = "List of conditions for the IAM binding."
  type = list(object({
    title       = string
    description = string
    expression  = string
  }))
  default = []
}

resource "google_project_iam_binding" "project_binding" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  members = var.members

  dynamic "condition" {
    for_each = var.conditions
    content {
      title       = condition.value.title
      description = condition.value.description
      expression  = condition.value.expression
    }
  }
}
