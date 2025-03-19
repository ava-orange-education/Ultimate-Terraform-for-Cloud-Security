package example.nsg  
deny[msg] {
  input.network_security_group.rules[_].destination_port_range == "0-65535"
  msg = "Open port detected – NSG must restrict access"
}
