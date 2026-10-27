resource "grafana_folder" "fuboot_tours" {
  provider = grafana.stack

  title = "FUBoot Tours"
}

locals {
  fuboot_tours_dashboard_files = {
    prod = "${path.module}/dashboards/fuboot-tours-prod.json"
    stg  = "${path.module}/dashboards/fuboot-tours-stg.json"
  }

  fuboot_tours_dashboards = {
    for env, path in local.fuboot_tours_dashboard_files :
    env => merge(jsondecode(file(path)), { id = null })
  }

  # Inject CF zoneTag + GitHub owner/repo into dashboard textbox variables.
  fuboot_tours_dashboards_with_zone = {
    for env, dash in local.fuboot_tours_dashboards :
    env => merge(
      dash,
      {
        templating = {
          list = [
            for v in dash.templating.list : (
              v.name == "cf_zone" && var.cloudflare_zone_tag != null ? merge(v, {
                query   = var.cloudflare_zone_tag
                current = { text = var.cloudflare_zone_tag, value = var.cloudflare_zone_tag }
                }) : v.name == "gh_owner" ? merge(v, {
                query   = var.github_owner
                current = { text = var.github_owner, value = var.github_owner }
                }) : v.name == "gh_repo" ? merge(v, {
                query   = var.github_repository
                current = { text = var.github_repository, value = var.github_repository }
              }) : v
            )
          ]
        }
      },
    )
  }
}

resource "grafana_dashboard" "fuboot_tours_env" {
  for_each = local.fuboot_tours_dashboards_with_zone

  provider = grafana.stack

  folder      = grafana_folder.fuboot_tours.uid
  config_json = jsonencode(each.value)
  overwrite   = true
}
