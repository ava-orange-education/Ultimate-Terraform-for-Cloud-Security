resource "tfe_team" "dev_team" {
  name         = "Development Team"
  organization = "example-org"
}

resource "tfe_team_access" "workspace_access" {
  workspace_id = tfe_workspace.example.id
  team_id      = tfe_team.dev_team.id
  access       = "plan"
}
