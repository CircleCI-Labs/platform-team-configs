# How to destroy this created project
output "message" {
  value = "Created new project ${circleci_project.team_project.name} and restricted context."
}

output "project_url" {
  value = "https://app.circleci.com/projects/${circleci_project.team_project.slug}"
}

output "org_slug" {
  value = circleci_project.team_project.slug
}

output "context_url" {
  value = "https://app.circleci.com/settings/organization/${var.org_info.organization_slug}/contexts/${circleci_context.team_context.id}"
}

output "existing_context_restriction_id" {
  description = "ID of the project restriction added to the existing context"
  value = circleci_context_restriction.existing_context_project_restriction.id
}

output "existing_context_name" {
  description = "Name of the existing context that was restricted"
  value = data.circleci_context.existing_context.name
}

output "default_pipeline_id" {
  value = circleci_pipeline.default.id
}

output "github_repo_url" {
  value = github_repository.new_repo.html_url
}

output "github_repo_clone_url" {
  value = github_repository.new_repo.git_clone_url
}

output "template_repo_id" {
  value = data.github_repository.template_repo.repo_id
}

output "template_repo_url" {
  value = data.github_repository.template_repo.html_url
}

# Debug outputs for ID formats
output "debug_new_repo_repo_id" {
  description = "Numeric repo ID of the newly created repository"
  value = github_repository.new_repo.repo_id
}

output "debug_new_repo_node_id" {
  description = "GraphQL node ID of the newly created repository"
  value = github_repository.new_repo.node_id
}

output "debug_template_repo_repo_id" {
  description = "Numeric repo ID of the template repository"
  value = data.github_repository.template_repo.repo_id
}

output "debug_template_repo_node_id" {
  description = "GraphQL node ID of the template repository"
  value = data.github_repository.template_repo.node_id
}

output "debug_platform_configs_repo_id" {
  description = "Numeric repo ID of the platform-team-configs repository"
  value = data.github_repository.platform_configs_repo.repo_id
}

output "context_info" {
  #loop all created contexts, and look up the set of values to inject
  for_each = var.appteam_pipeline_profiles.context_variables

  description = "context for ${each.key}"
  value      = "name: ${each.key}, value:${var.app_team_passwords[each.key]}, context_id: ${circleci_context.team_context.id}"
}
