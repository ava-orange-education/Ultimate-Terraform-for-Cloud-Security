module "monitoring_dashboard" {
  source  = "terraform-google-modules/monitoring-dashboard/google"
  version = "~> 1.0"

  dashboards = [
    {
      display_name = "Example Dashboard"
      row = [
        {
          panels = [
            {
              title = "CPU Utilization"
              type  = "metric"
              data = [
                {
                  filter = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
                  aggregation = {
                    alignment_period   = "60s"
                    per_series_aligner = "ALIGN_MEAN"
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
