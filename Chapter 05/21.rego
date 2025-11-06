package example.gce  
deny[msg] {
  input.gce_instance.network_interface.access_config != null
  msg = "GCE instances must not have external IP addresses"
}
