# FUBoot Tours AWS Terraform

One AWS account, two environments. **S3 + CloudFront only** (no Lambda API).

| Env | Root | Hostname |
|-----|------|----------|
| Staging | [`envs/stg`](envs/stg) | `fuboot-stg.7oas7er.com` |
| Production | [`envs/prod`](envs/prod) | `fuboot.7oas7er.com` |

Shared module: [`modules/site`](modules/site). GitHub OIDC provider is **account-wide** (looked up via data source in stg and prod — created by the first app in this account).

Bootstrap root: [`bootstrap`](bootstrap) creates the shared S3 state bucket.

## Remote state

| Root | State key |
|------|-----------|
| `bootstrap` | `bootstrap/terraform.tfstate` |
| `envs/stg` | `envs/stg/terraform.tfstate` |
| `envs/prod` | `envs/prod/terraform.tfstate` |
| `../cloudflare` | `cloudflare/terraform.tfstate` |
| `../grafana` | `grafana/terraform.tfstate` |

- Bucket: `shared-fuboot-tours-terraform-state-bucket` (versioned, encrypted, private)
- Locking: S3 native lock files (`use_lockfile = true`); requires Terraform **>= 1.10**

## Resource naming

`[environment]-fuboot-tours-[purpose]-[resource-type]`

Examples for `stg`:

- `stg-fuboot-tours-site-bucket`
- `stg-fuboot-tours-access-logs-bucket`
- `stg-fuboot-tours-github-deploy-role`
- `stg-fuboot-tours-site-oac`
- `stg-fuboot-tours-site-distribution`
- `stg-fuboot-tours-site-5xx-alarm`

Shared bootstrap: `shared-fuboot-tours-…`. Project tag: `fuboot-tours`.

The site bucket is not versioned — `site/` in git is the source of truth.

## Apply order

1. Apply **bootstrap** once.
2. Request/validate ACM certs in `us-east-1` for both hostnames; set `site_certificate_arn` in each env’s `terraform.tfvars`.
3. Set matching `origin_verify_secret` values in app env tfvars **and** platform `shared-edge` tfvars (`fuboot_stg_*` / `fuboot_prod_*`).
4. Apply **platform shared-edge** (origin-verify + cache hosts) **before** or with the CloudFront gate.
5. Apply **stg**, then app Cloudflare DNS (`stg_cloudfront_domain_name`), then Grafana.
6. Apply **prod** when promoting; update Cloudflare prod CNAME.
7. Wire GitHub Environments `staging` / `production` / `terraform` with deploy and plan role ARNs, bucket, distribution id, `SITE_HOST`, `CLOUDFLARE_ZONE_ID`, and `CLOUDFLARE_API_TOKEN`.

See also [`docs/architecture.md`](../../../docs/architecture.md).

## Access logging

Private `{env}-fuboot-tours-access-logs-bucket` (SSE-S3, Block Public Access, 90-day lifecycle):

- CloudFront standard logging v2 → prefix `cloudfront/`
- S3 site access logs → prefix `s3-site/`

## CloudWatch alarms

- CloudFront **5xxErrorRate** > 5% (us-east-1, Global dimension). No Lambda alarms.

## Cloudflare origin verify

CloudFront rejects requests missing `X-Origin-Verify`. Platform `shared-edge` injects the header for `fuboot.7oas7er.com` and `fuboot-stg.7oas7er.com`. Direct `*.cloudfront.net` URLs return 403.

This repo’s Cloudflare root is **DNS only**.
