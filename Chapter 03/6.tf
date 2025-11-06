variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}


variable "instance_count" {
  description = "Number of instances"
  type        = number
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
