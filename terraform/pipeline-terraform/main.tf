# Data source to fetch template repository information
data "github_repository" "template_repo" {
  name = var.appteam_pipeline_profiles.application_template
}

# Data source to fetch platform-team-configs repository (where config templates are stored)
data "github_repository" "platform_configs_repo" {
  name = "platform-team-configs"
}

# Data source to fetch existing CircleCI context
data "circleci_context" "existing_context" {
  id = "0731337b-c13e-402c-9159-4119e0240d19"
}

# Extract language from template name and construct config path
locals {
  # Extract language from template name (e.g., "python-starter-template" -> "python")
  language = split("-", var.appteam_pipeline_profiles.application_template)[0]
  config_path = "config-templates/${local.language}/config.yml"
}

# Create the GitHub repository first
resource "github_repository" "new_repo" {
  name        = var.appteam_pipeline_profiles.application_name
  description = "Created from template"
  visibility  = "internal"

  template {
    owner      = var.appteam_pipeline_profiles.template_owner
    repository = var.appteam_pipeline_profiles.application_template
  }
}

resource "circleci_project" "team_project" {
  #for_each = toset(var.appteam_pipeline_profiles)
  name             = var.appteam_pipeline_profiles.application_name
  organization_id  = var.org_info.organization_id
  project_provider = var.org_info.project_provider
  
}

resource "circleci_context" "team_context" {
  #for_each = toset(var.appteam_pipeline_profiles)
  name            = var.appteam_pipeline_profiles.context_name
  organization_id = var.org_info.organization_id
}

resource "circleci_context_restriction" "context_restrictions" {
  for_each   = var.appteam_pipeline_profiles.context_restrictions
  context_id = circleci_context.team_context.id
  type       = each.key
  value      = (each.key == "project") ? circleci_project.team_project.id : var.context_restrictions[each.value]
}

resource "circleci_context_environment_variable" "team_variables" {
  #loop all created contexts, and look up the set of values to inject
  for_each = var.appteam_pipeline_profiles.context_variables

  context_id = circleci_context.team_context.id
  name       = each.value
  value      = var.app_team_passwords[each.key]

}

# Add project restriction to existing context
resource "circleci_context_restriction" "existing_context_project_restriction" {
  context_id = data.circleci_context.existing_context.id
  type       = "project"
  value      = circleci_project.team_project.id

}

resource "circleci_pipeline" "default" {
  name                             = "default"
  description                      = "Run on all commits"
  project_id                       = circleci_project.team_project.id
  checkout_source_provider         = "github_app"
  checkout_source_repo_external_id = github_repository.new_repo.repo_id
  config_source_file_path          = local.config_path
  config_source_provider           = "github_app"
  config_source_repo_external_id   = data.github_repository.platform_configs_repo.repo_id

}

resource "circleci_trigger" "default" {
  name                          = "default"
  description                   = "Default trigger created by Platform Team"
  pipeline_id                   = circleci_pipeline.default.id
  project_id                    = circleci_project.team_project.id
  event_source_provider         = "github_app"
  event_source_repo_external_id = github_repository.new_repo.repo_id
  event_preset                  = "all-pushes"
  config_ref                    = "main"
  checkout_ref                  = ""

}