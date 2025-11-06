terraform {
  cloud {
    organization = "MyOrg"
    workspaces {
      name = "production"
    }
  }
}
