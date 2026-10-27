locals {
  zone_id = var.zone_id
}

# App hostnames only — apex/www stay with the homepage / zone owner (not this app).
resource "cloudflare_dns_record" "fuboot" {
  zone_id = local.zone_id
  name    = "fuboot.7oas7er.com"
  type    = "CNAME"
  content = var.prod_cloudfront_domain_name
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "fuboot_stg" {
  zone_id = local.zone_id
  name    = "fuboot-stg.7oas7er.com"
  type    = "CNAME"
  content = var.stg_cloudfront_domain_name
  proxied = true
  ttl     = 1
}
