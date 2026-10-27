output "grafana_stack_id" {
  description = "Grafana Cloud stack ID used for Cloud Provider resources."
  value       = data.grafana_cloud_stack.fuboot_tours.id
}

output "grafana_stack_url" {
  description = "Grafana Cloud stack URL."
  value       = data.grafana_cloud_stack.fuboot_tours.url
}

output "grafana_cloudwatch_role_arn" {
  description = "IAM role Grafana Cloud assumes for CloudWatch metric scrape."
  value       = aws_iam_role.grafana_cloudwatch.arn
}

output "grafana_aws_external_id" {
  description = "External ID currently required by the CloudWatch IAM trust policy."
  value = coalesce(
    var.grafana_aws_external_id,
    tostring(data.grafana_cloud_stack.fuboot_tours.prometheus_user_id),
  )
}

output "cloudwatch_scrape_job_name" {
  description = "Name of the CloudWatch scrape job in Grafana Cloud (null while enable_cloudwatch_scrape is false)."
  value       = try(grafana_cloud_provider_aws_cloudwatch_scrape_job.fuboot_tours[0].name, null)
}

output "enable_cloudwatch_scrape" {
  description = "Whether Cloud Provider AWS account + scrape job resources are managed."
  value       = var.enable_cloudwatch_scrape
}

output "synthetic_check_jobs" {
  description = "Synthetic Monitoring job names."
  value = [
    grafana_synthetic_monitoring_check.prod_site.job,
    grafana_synthetic_monitoring_check.stg_site.job,
    grafana_synthetic_monitoring_check.prod_scores.job,
    grafana_synthetic_monitoring_check.stg_scores.job,
  ]
}

output "fuboot_tours_dashboard_urls" {
  description = "URLs of the FUBoot Tours Production and Staging dashboards."
  value = {
    for env, dash in grafana_dashboard.fuboot_tours_env : env => dash.url
  }
}

output "fuboot_tours_folder_uid" {
  description = "UID of the FUBoot Tours Grafana folder."
  value       = grafana_folder.fuboot_tours.uid
}

output "cloudflare_edge_datasource_uid" {
  description = "Shared Infinity Cloudflare GraphQL data source UID (platform shared-obs)."
  value       = local.enable_cloudflare_edge ? "infinity-cloudflare" : null
}

output "github_ci_datasource_uid" {
  description = "GitHub data source UID (null if not provisioned)."
  value       = try(grafana_data_source.github[0].uid, null)
}

output "enable_cloudflare_edge" {
  description = "Whether FUBoot Tours dashboard Cloudflare panels expect shared Infinity + zoneTag."
  value       = local.enable_cloudflare_edge
}

output "enable_github_ci" {
  description = "Whether the GitHub data source is managed."
  value       = local.enable_github_ci
}
