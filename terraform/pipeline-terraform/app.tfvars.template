  org_info = {
    organization_id   = "${ORG_ID}"
    organization_slug = "${ORG_SLUG}"
    project_provider  = "circleci" #only provider supported currently
  }


  appteam_pipeline_profiles ={
    "application_name" : "${APP_NAME}"
    "application_template" : "${TEMPLATE}"
    "template_owner" : "${TEMPLATE_OWNER}"
    "context_name" = "${APP_NAME}_prod"
    "context_restrictions" = {
      "project"    = "dynamic",
      "expression" = "default_branch_only"
    }
    "context_variables" = [
      "deployer_name",
      "deployer_secret"
    ]
  }
  
  context_restrictions = {
    "default_branch_only" = "git.branch == \"main\""
  }

  app_team_passwords = {
    "deployer_name"   = "${APP_NAME}_account_prod"
    "deployer_secret" = "${DEPLOYER_SECRET}"
  }