locals {
  # Naming: [environment]-fuboot-tours-[purpose]-[resource-type]
  name_prefix = "${var.environment}-fuboot-tours"

  site_bucket_name                  = "${local.name_prefix}-site-bucket"
  access_logs_bucket_name           = "${local.name_prefix}-access-logs-bucket"
  cloudfront_log_delivery_name      = "${local.name_prefix}-cloudfront-access-logs"
  cloudfront_5xx_alarm_name         = "${local.name_prefix}-site-5xx-alarm"
  github_deploy_role_name           = "${local.name_prefix}-github-deploy-role"
  github_deploy_policy_name         = "${local.name_prefix}-github-deploy-policy"
  site_oac_name                     = "${local.name_prefix}-site-oac"
  site_origin_id                    = "${local.name_prefix}-site-origin"
  site_distribution_name            = "${local.name_prefix}-site-distribution"
  origin_verify_function_name       = "${local.name_prefix}-origin-verify-function"
  site_response_headers_policy_name = "${local.name_prefix}-security-headers-policy"
  cache_policy_caching_optimized    = "658327ea-f89d-4fab-a63d-7e88639e58f6"

  # Static VRML + X_ITE from jsDelivr; play pages use inline script/style.
  content_security_policy = join("; ", [
    "default-src 'self'",
    "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net",
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' data: blob:",
    "font-src 'self' data:",
    "connect-src 'self' https://cdn.jsdelivr.net",
    "worker-src 'self' blob:",
    "child-src 'self' blob:",
    "media-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'self'",
    "upgrade-insecure-requests",
  ])
  permissions_policy = join(", ", [
    "accelerometer=()",
    "camera=()",
    "geolocation=()",
    "gyroscope=()",
    "magnetometer=()",
    "microphone=()",
    "payment=()",
    "usb=()",
    "interest-cohort=()",
  ])
}
