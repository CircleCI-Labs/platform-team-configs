# DEMO.md — platform-team-configs (Paved Road / Self-Service)

| | |
|---|---|
| **Catalog use case** | 2 · Platform Engineering & Golden Path |
| **Owner** | Derry Bradley |
| **Repos** | [platform-team-configs](https://github.com/CircleCI-Labs/platform-team-configs) (platform side) · [python-starter-template](https://github.com/CircleCI-Labs/python-starter-template) (dev side) |
| **Stack** | Port (portal) → CircleCI (automation) → Terraform (orchestration) → GitHub + CircleCI (output) |
| **Formats** | Full session, ~45 min + Q&A (PlatformCon run of show, below) · Short customer version, ~12 min (section 10) |
| **Status** | DRAFT. Talk track checked against `main`. See section 11 before you claim anything about security scanning. |

**The story in one line:** a developer fills in a form in Port, and about 2 minutes later has a GitHub repo, a CircleCI project, a scoped context and a running pipeline built on platform-team templates. There's no ticket and no Slack thread.

---

## 0. Pre-flight (the day before and 30 minutes before)

- [ ] **Pick a fresh service name.** The demo default is `user-registration-service`. It must not already exist as a GitHub repo or CircleCI project; if it does, run deprovision first (section 9).
- [ ] **Check the provisioning context.** The `centralized-asset-github-envs` context needs valid values for:
  - `GITHUB_TOKEN`
  - `CIRCLE_TOKEN`
  - `AWS_ACCOUNT_ID`
  - `AWS_IAM_PREFIX`
  - `GITHUB_ORG`

  Expired tokens are the most common reason this demo fails.
- [ ] **Check the Port action.** Its webhook must point at the custom webhook trigger on the `platform-team-configs` project. The payload keys must be `template_repo` and `target_repo`, because `parse-webhook-payload` upper-cases every key into an env var.
- [ ] **Check the URL orb allow-list.** Organization Settings → Orbs must allow `https://raw.githubusercontent.com/CircleCI-Labs/`.
- [ ] **Have a pre-provisioned backup project.** `user-auth-service` already exists and should have a green pipeline. If the live provision is slow, cut to it.
- [ ] **Do a dry run.** Provision a throwaway service the day before, then deprovision it. That confirms that state, tokens and the provider build all work.
- [ ] **Open these tabs:**
  - the Port form
  - `platform-team-configs` pipelines in CircleCI
  - `platform-team-configs` on GitHub
  - `python-starter-template` on GitHub
  - `user-auth-service` in CircleCI and on GitHub
  - Cursor with the CircleCI MCP server connected
- [ ] **Check the screen-share tabs.** Close anything that shows a customer org or pipeline. Your notes include a customer pipeline URL; don't put it on screen.

---

## Run of show

| # | Section | Time | Driver | Poll |
|---|---|---|---|---|
| 1 | Intro | 4:30 | Slides 1–3 | — |
| 2 | The problem | 9:30 | Slides 4–9 | Slides 4, 6, 8 |
| 3 | The Paved Road demo | 9:30 | Live: Port → CircleCI → GitHub | Opening slide 10 + "who uses CircleCI today?" |
| 4 | Terraform / infra as code | 7:00 | Live: repo + `main.tf` | Opening |
| 5 | Centralized config, templates and overrides | 6:11 | Live: templates + `team-config.yml` | Opening + mid-section |
| 6 | Developer experience | TBD | Live: Cursor + CircleCI MCP | Opening |
| 7 | Guardrails | TBD | Live: policies, contexts, OIDC | — |
| 8 | Wrap-up and Q&A | TBD | Slides | — |

Eddie takes questions in chat throughout. The main Q&A is at the end.

---

## 1. Intro (4:30) — slides 1–3

| Slide | Say |
|---|---|
| 1 | "I'm Derry. Today I'll show how platform teams can give developers real self-service using Port, CircleCI and Terraform, live and end to end." |
| 2 | Who you are, your platform-team and software-delivery background, and a fun fact. Then the goal: "**Let devs move fast on paved paths while platform teams stay in control with automation and guardrails.**" |
| 3 | The agenda. "Eddie is in chat answering questions as we go. Drop them in any time, and there's plenty of Q&A at the end." |

---

## 2. The problem (9:30) — slides 4–9

**Slide 4 — Poll** to open.

**Slide 5 — the story.** "Imagine I'm a developer spinning up a new service. I ping the platform team in Slack, open a Jira ticket, and wait: a day, two days, maybe longer. Someone wires up the repo, secrets and pipeline. It's slow." *Pause.* "We're going to fix that. Port is the portal, CircleCI is the automation and Terraform orchestrates it all. Developers go from zero to CI/CD without a ticket."

**Slide 6 — Poll, then the four steps:**
1. **Ping in Slack.** "Can someone help me create a repo?" You're at the mercy of whoever notices.
2. **File a ticket.** A vague Jira ticket, assigned to the platform team, followed by hours or days of waiting.
3. **Wait for infra.** Eventually someone sets up the repo, the pipeline, the secrets and a baseline config.
4. **Copy-paste config.** You copy YAML from a repo that "kind of works" and tweak it until it runs.

"This is normal, and it shouldn't be. It's slow, it's risky, and it breeds config drift."

**Slide 7 — the cost of not solving it:**
- **Delayed time to value.** Days lost waiting for environments, pipelines and secrets.
- **Shadow pipelines and drift.** When the platform team can't keep up, developers build their own pipelines outside the standards.
- **Platform team burnout.** Senior engineers end up doing ticket ops.
- **Security risk.** Slow governance gets routed around, which leaves unknown repos, unknown pipelines and open deploys. That's an audit problem.

"Self-service isn't a nice-to-have. It's table stakes."

**Slide 8 — Poll, then the stack:** "Port is the UX, Terraform is the orchestrator and CircleCI is the automation engine."

**Slide 9 — the flow you're about to see:** form → webhook → CircleCI provisioning pipeline → Terraform → GitHub repo + CircleCI project + context + pipeline + trigger → empty commit → first build.

---

## 3. The Paved Road demo (9:30) — live

Open with the slide 10 poll. Then:

| Show | Say |
|---|---|
| **Port form.** Fill in `user-registration-service`, pick the Python template, click **Create**. | "Instead of filing a ticket, the developer opens Port. Fill in the form, click Create, and go get a coffee. In about 2 minutes everything's ready." |
| **CircleCI → `platform-team-configs` → the `provision-infrastructure` workflow running.** | "Port sent a webhook to CircleCI, and that triggered this provisioning pipeline. CircleCI is the self-service engine here." |
| **The `configure-cci` job steps.** Point at the webhook parse, the provider build, the OIDC login and `terraform apply`. | "The job reads the form data from the webhook, logs into AWS with OIDC for Terraform state, and runs Terraform with the CircleCI and GitHub providers." |
| **`python-starter-template` on GitHub.** | "Terraform creates the new repo from this template. Our organization's best practices and boilerplate are already in it." |
| **Terraform apply output.** Scroll to the resources and outputs. | "Using the CircleCI Terraform provider, it creates the project and a context, adds the secrets and restrictions, and sets up the pipeline and trigger. It's all code, with no CLI or manual steps. We'll go under the hood in a minute." |
| *Switch to the backup project while provisioning finishes.* **CircleCI → `user-auth-service`.** Poll: "How many of you use CircleCI today?" | "Here's one we made earlier. The pipeline ran on its own: the provisioning job pushed an empty commit to kick off the first build, so the developer knows it's live." |
| **Walk the pipeline: Build → Test → Deploy.** Give the poll audience a quick overview of pipelines, workflows and jobs. | "This pipeline comes from the platform team's central templates in `platform-team-configs`." |
| **Project settings → Pipelines:** config source, config file path, checkout source. | "This is centralized config. The **config source** is the platform repo at `config-templates/python/config.yml`. The **checkout source** is the developer's repo. The platform team owns the baseline, and the developer owns the code." |
| **New repo on GitHub:** `.circleci/team-config.yml`, pre-commit hooks, Dockerfile. | "The developer gets boilerplate with PEP standards, pre-commit linting and Docker support, plus a `team-config.yml` where they can override parts of the pipeline. More on that in section 5." |

**Close the section:**
- "From the developer's side, it took 2 minutes to go from an idea to a running pipeline. No tickets, no waiting, and the platform team didn't touch it."
- "Developers move fast, platform teams stay in control, and everyone wins."

**Slide 11 — why self-service matters:**
- **Developers don't wait.** No tickets and no Slack threads.
- **Platform teams don't hand-hold.** Standards are defined once, in code, and applied everywhere.
- **Guardrails are built in.** Context scoping, branch restrictions, config policies and platform-owned jobs are there by default.
- **You get velocity and governance.** You don't have to trade one for the other.
- Close on "best-of-breed orchestration instead of lock-in to a monolithic platform."

---

## 4. Terraform / infra as code (7:00) — live

Open with the poll. "This is how we turned CircleCI project provisioning into a self-service flow: inputs in, pipelines out."

### 4.1 Repo tour

| Path | What it is |
|---|---|
| `.circleci/provision.yml` | The webhook- or API-triggered provisioning pipeline |
| `.circleci/deprovision.yml` | The API-triggered teardown pipeline |
| `.circleci/config-policies.yml` | Test, diff and push for config policies |
| `.circleci/terraform_provider/app.tfvars` | The tfvars **template**. `${APP_NAME}`, `${TEMPLATE}` and so on are filled in at runtime by `circleci env subst` |
| `terraform/pipeline-terraform/` | `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf` |
| `config-templates/` | Platform-owned pipeline templates. `python/` and `nodejs/` are wired to starter templates and have override hooks. `base/` and `docker/` are simple skeletons without hooks |
| `orbs/platform-team.yml` | URL orb: `parse-webhook-payload`, `parse-ui-parameters`, `setup-tf-vars`, `build-terraform-provider-circleci` |
| `policies/` | OPA/Rego config policies |
| `docs/` | Best practices and override examples |

"Platform teams manage reusable patterns in one place. App teams onboard without dealing with low-level details."

### 4.2 Inputs: `app.tfvars`

"Provisioning starts from a handful of inputs."
- **`org_info`:** the CircleCI org ID and slug.
- **`appteam_pipeline_profiles`:** the app.
  - `application_name`: comes from the Port form.
  - `application_template`: for example `python-starter-template`.
  - `context_name`: `${APP_NAME}_prod`.
  - `context_restrictions`: a `project` restriction to this new project, plus an `expression` restriction of `git.branch == "main"`.
  - `context_variables`: `deployer_name` and `deployer_secret`.
- **`app_team_passwords`:** the values injected into the context.

*If asked where the deployer secret comes from:* in this demo it's a placeholder set in the `setup-tf-vars` orb command (`DEPLOYER_SECRET='pulledfromvault'`). "In production, that line reads from your secret manager."

### 4.3 What `main.tf` does, step by step

**Step 1 — Lookups and repo.** "First, Terraform gathers what it needs."
- It looks up the template repo and the `platform-team-configs` repo.
- It reads an existing shared CircleCI context.
- It works out the config path from the template name: `python-starter-template` → `config-templates/python/config.yml`.
- It creates the new GitHub repo from the template (`github_repository.new_repo`, internal visibility).

**Step 2 — CircleCI project and context.** `circleci_project`, `circleci_context` (`<app>_prod`) and `circleci_context_environment_variable` for each secret. "Every project gets its own isolated context, so secrets don't leak between applications."

**Step 3 — Restrictions.** `circleci_context_restriction` locks the new context to **this project** and to the **main branch only**. A second restriction adds the new project to the existing shared context. "No more 'can you add me to the prod context?' messages. Access follows rules."

**Step 4 — Pipeline.** `circleci_pipeline.default`: "Notice the two sources. **Config comes from the platform repo, and code comes from the app repo.** That's how centralized config works, and it's versioned and traceable."

**Step 5 — Trigger.** `circleci_trigger.default` with `event_preset = "all-pushes"`. Every push builds, and the config is read from `main` of the platform repo.

"About 2 minutes from form submission to a working project with CI/CD, scoped secrets and the platform's standards."

### 4.4 `outputs.tf`

Point at `project_url`, `context_url`, `github_repo_url` and `default_pipeline_id`. "Everything you just built is printed at the end, ready to send back to Port or Slack."

### 4.5 `providers.tf`

- **State:** an S3 backend with DynamoDB locking. Each app gets its own state key: `fe-platform-demo/port/<app>.tfstate`. "One app's apply can't touch another's state."
- **CircleCI provider:** v2 API, authenticated with `CIRCLE_TOKEN`. The orb builds it from source at a pinned commit.
- **GitHub provider:** authenticated with `GITHUB_TOKEN`.

### 4.6 Tie it together

- No copy-pasted config
- Scoped secrets and guardrails
- Repos and pipelines are traceable
- Standard patterns across teams
- "Everything is code, so it gets reviewed, automated and kept consistent."

---

## 5. Centralized config, templates and overrides (6:11) — live

Open with the poll.

**Hook:** "We've automated project creation. But how do we stay consistent across hundreds of teams and still give developers flexibility?"

**The two problems:**
- Copy-pasted config leads to drift.
- Rigid templates leave developers stuck.

"We need standardization **and** flexibility." Run the second poll here.

### 5.1 Platform templates — `config-templates/`

"Each stack has a platform-owned template that defines the workflow, the job order and the jobs nobody else touches."

### 5.2 How the override works — `config-templates/python/config.yml`

```yaml
orbs:
  team-config: << pipeline.parameters.config-override-url >>
# default: https://raw.githubusercontent.com/<owner>/<repo>/<revision>/.circleci/team-config.yml
...
- build:
    override-with: team-config/build
```

| Point | Say |
|---|---|
| **The URL orb** | "The template imports the developer's own `team-config.yml` as an orb, directly from their repo at the exact commit being built. Nothing gets published." |
| **`override-with`** | "This is the hook. If the team defines `build`, theirs runs. If they don't, they get the platform default." |
| **What isn't overridable** | Switch to `config-templates/nodejs/config.yml`. "The `lint` job has no `override-with`. It's platform-enforced, and every Node project runs it. Deploy only runs on `main`." This is the clearest example in the repo; see section 11. |

### 5.3 The developer's side — `python-starter-template/.circleci/team-config.yml`

- **`build` is overridden:** a machine executor with Docker layer caching, plus a Docker build.
- **`test` is overridden:** `cimg/python`, a pip cache, and pytest with JUnit results.
- **`deploy` isn't defined, so it stays default:** "They inherit the platform's deploy job without writing it."
- "Flexibility where they need it, consistency everywhere else."

### 5.4 Show it in `user-auth-service`

Open a pipeline and show the Build, Test and Deploy jobs running the team's build and test with the platform's deploy.

### 5.5 Who benefits

- **Platform team:** one template, governed hooks, and a fix made once applies everywhere.
- **Developers:** a working pipeline in minutes and no CI expertise needed.
- **Org:** consistent practice across hundreds of teams and less CI maintenance.

**Key line:** "Standardization plus flexibility equals scale. The paved road becomes the easiest path."

---

## 6. Developer experience (TBD) — live

Open with the poll.

**Hook:** "Let's switch perspectives. What does it feel like to be the developer who just got this project?"

1. **Clone `user-auth-service` and open it in Cursor.** Point out the boilerplate, the `.circleci/` folder, the pre-commit hooks and the Dockerfile. Note that there's only a `team-config.yml`, because the main config lives with the platform team.
2. **Show the CircleCI IDE extension.**
3. **Show the CircleCI MCP server connected in Cursor.** "MCP lets an AI assistant talk directly to CircleCI." Prompts that map to real MCP tools:
   - "What's the status of my latest pipeline?" → `get_latest_pipeline_status`
   - "Why did my last build fail?" → `get_build_failure_logs`
   - "Validate my team-config.yml" → `config_helper`
   - "Do I have flaky tests?" → `find_flaky_tests`
   - Optional extra: "rerun the workflow" → `rerun_workflow`
4. **Before and after.**
   - Before: the UI, digging through logs, Googling the docs.
   - After: you stay in the IDE, with answers about **your** pipeline.

**Key line:** "The best platform engineering creates an experience developers never want to give up."

**Prep tip:** break a test on a branch before the session so the "why did it fail?" prompt has a real answer.

---

## 7. Guardrails (TBD) — live

**Hook:** "If anyone can create pipelines, how do you keep security and standards? With guardrails that keep people safe while they go fast."

**The philosophy:** too rigid and people work around it, too loose and things drift. "Guardrails should be automatic and hard to bypass."

### 7.1 Config policies — `policies/python-version/`

- Rego/OPA checks every `cimg/python` image in the **compiled** config against a minimum of **3.13.5**.
- `enable_rule` with no hard fail makes it a **soft warning**: builds continue, the developer gets a message with a fix link, and the platform team gets visibility.
- **Live moment:** the starter template's test job uses `cimg/python:3.13.4`, so a freshly provisioned project **will** trigger the warning. Show it on the `user-auth-service` pipeline. "The policy caught it on day one, and nobody filed a ticket."
- **Likely Q&A trap:** the policy only checks CircleCI executor images (`cimg/python:*`). It does **not** see the app's `Dockerfile`, which uses `python:3.11-slim`. If asked, say: "Config policies govern the pipeline. Image contents are a job for a scanner step."
- **Policies are managed as code** in `.circleci/config-policies.yml`. Every branch runs list and test, with JUnit results. Feature branches show a **diff** of what would change. A merge to `main` **pushes** the bundle to the org. There's also an enable/disable toggle you can run from the UI.

### 7.2 OIDC for the platform's own infra

"The provisioning pipeline never stores AWS keys. `aws-cli/setup` swaps a CircleCI OIDC token for a short-lived role session for Terraform state, and the session name includes the pipeline number for the audit trail."

Say it this way: the **GitHub and CircleCI tokens** are still API tokens kept in a restricted context. OIDC covers AWS.

### 7.3 Contexts as access control

The code that runs:

```hcl
resource "circleci_context_restriction" "context_restrictions" {
  for_each   = var.appteam_pipeline_profiles.context_restrictions
  context_id = circleci_context.team_context.id
  type       = each.key            # "project" or "expression"
  value      = (each.key == "project") ? circleci_project.team_project.id
                                       : var.context_restrictions[each.value]  # git.branch == "main"
}
```

- **Project restriction:** only this project can use `<app>_prod`.
- **Expression restriction:** only `main` gets the production secrets, and feature branches don't.
- **Shared contexts:** the new project is granted access to an existing org context. That access comes from code, not from someone clicking in the UI.
- **The provisioning context** (`centralized-asset-github-envs`) and `policy-management` should be restricted to the platform team.

### 7.4 Template-based guardrails

- Platform-owned jobs that have no `override-with` (for example Node `lint`) **always run**.
- The workflow structure and job order belong to the platform template, not the team.
- The deploy filter to `main` lives in the template.

### 7.5 Lifecycle: deprovisioning

`.circleci/deprovision.yml` is triggered by the API with `target_repo`. It runs `terraform destroy` against that app's state and removes the repo, project and context. "Onboarding and offboarding are both self-service, and neither leaves orphaned secrets."

---

## 8. Wrap-up and Q&A (TBD)

"What you've seen is a modular, repeatable and secure way to bootstrap app teams on CircleCI. One form, one pipeline and one `terraform apply`:"
- Create a GitHub repo from a template
- Set up a CircleCI project with centralized config
- Create a scoped context with branch and project restrictions
- Apply org-wide config policies automatically
- Kick off the first pipeline with an empty commit

**Platform teams get:** one consistent setup process, secrets scoped by design, and no snowflake configs.
**App teams get:** a working pipeline, their repo, injected credentials, and links to everything (`outputs.tf`).

**Why it matters:**
- Less ticket churn
- Least privilege by design
- Centralized config without losing velocity
- A launchpad for 1 app or 100

**Q&A:** "Bring your use case and we'll talk through how it fits this model."

---

## 9. If it breaks

| Symptom | Likely cause | Recovery |
|---|---|---|
| Port click does nothing | Webhook URL or trigger misconfigured | Trigger `provision.yml` from the CircleCI UI with `template_repo` and `target_repo` (the `api` path in the workflow `when`) |
| `terraform apply` fails on the GitHub repo | Repo name already exists | Use the backup project. Afterwards, run deprovision with that `target_repo` |
| Auth errors in apply | Expired `GITHUB_TOKEN` or `CIRCLE_TOKEN` | Cut to the backup project and rotate the tokens after the session |
| Provider build is slow | Cache miss building the provider from source | Talk through section 4 while it builds; it's cached after the first run |
| New project picks up config changes late | URL orb cache (about 5 minutes) | "URL orbs cache briefly. Pin to a SHA for instant, immutable versions." |

---

## 10. Short version (~12 min, customer calls)

1. **The problem, in one sentence** (1 min).
2. **Port → Create, then the provisioning pipeline running** (3 min).
3. **`main.tf` Step 4:** "config from the platform, code from the app" (2 min).
4. **The template's `override-with` and the starter's `team-config.yml`** (3 min).
5. **Context restrictions and the Python policy warning** (2 min).
6. **Close:** "Developers move fast, platform stays in control" (1 min).

---

## 11. Don't say, and fix before claiming it

These lines from the original script don't match what's in the repo today.

| Claim in the script | What the repo actually has | Do this |
|---|---|---|
| "Developers can't override security scanning, approval gates or compliance" | The Python template has **no** security, approval or compliance jobs, and **all three** jobs (build, test, deploy) have `override-with`. The README says deploy isn't overridable, but the Python template allows it. | Use Node `lint` as the "can't override" example, or add a platform-owned `security-scan` job (no `override-with`) and an approval job to `config-templates/python/config.yml` |
| "Every template includes dependency, SAST, container and license scanning" and "compliance reporting" | Not implemented | Don't say it. Or add one scanner job and say "for example" |
| "Configures user permissions based on team membership" | Not in `main.tf` | Drop it |
| "A push to main kicks off the pipeline" | The trigger is `all-pushes`, so every branch builds. `main` only matters for which config is read | Say "every push" |
| Terraform "across CircleCI, GitHub, AWS providers" | Only the CircleCI and GitHub providers. AWS is just the S3/DynamoDB state backend | Say "AWS for state" |
| The HCL with a `restriction {}` block inside `circleci_context` | Restrictions are a separate `circleci_context_restriction` resource with `type = "expression"` | Use the snippet in 7.3 |
| "Fully passwordless" | OIDC covers AWS only. GitHub and CircleCI still use API tokens in a restricted context | Use the 7.2 wording |
| Templates for "Python, Node, Docker, Base" (and Java in the README) | All four folders exist, but only `python/` and `nodejs/` have `override-with` hooks and a matching starter repo. `base/` and `docker/` are skeletons with echo steps. There's no Java template | Say "Python and Node today, with Docker and Base skeletons" |

**Repo bugs to fix:**
1. **The Node path is broken.** `main.tf` takes the language from the template name (`node-starter-template` → `node`), but the folder is `config-templates/nodejs/`. Rename the folder to `node/`, or map the name in `locals`. Until then, **only demo Python**.
2. **The shared context ID is hardcoded.** The `existing_context` data source uses a literal ID. Move it to a variable and name the context in the talk track.
3. **The variable defaults include a placeholder secret** (`bad_s3cret` in `app_team_passwords`). It's overridden by `app.tfvars`, but a security audience reading `variables.tf` will notice. Remove the default.
4. **The orb echoes `DEPLOYER_SECRET` to the job log** in `setup-tf-vars`. Harmless with a placeholder value, but bad practice to show on stage. Remove the echo.
5. **Policy path filtering:** the README says the policy pipeline only runs when `policies/` changes, but `config-policies.yml` is gated on the `run-policy-workflow` parameter. Confirm what sets it before you claim path filtering.

---

## Open questions for Derry

- Timings for sections 6–8, so the run of show adds up to the slot.
- The wording of the poll questions for slides 4, 6, 8 and 10 and for sections 4–6.
- Is `override-with` on the hold list (preview vs GA) for this quarter? If it's preview, say so on stage.
- Which shared context is `0731337b-…`? (Probably `share-docker-publishing`.)
