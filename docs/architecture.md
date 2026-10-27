# Architecture — FUBoot Tours

Public static VRML archive + X_ITE play pages. Hosted like Block Drop / Netrunner: **app repo** owns AWS + Cloudflare DNS + Grafana app objects; **[`7oas7er/platform`](https://github.com/7oas7er/platform)** owns zone rulesets (shared-edge) and shared Grafana Free objects (shared-obs).

## Product

| Item | Value |
|------|--------|
| GitHub | `7oas7er/fuboot-tours` |
| Project tag | `fuboot-tours` |
| Prod host | `fuboot.7oas7er.com` |
| Staging host | `fuboot-stg.7oas7er.com` |
| Public tree | `site/` (landing + `site/vrml/`) |
| API | **None** (no high-scores Lambda) |

Local play (no AWS): `python3 serve-xite.py` serves `site/` on port 8765.

## Roots (Terraform)

| Root | Role |
|------|------|
| `infra/terraform/aws/bootstrap` | State bucket `shared-fuboot-tours-terraform-state-bucket` |
| `infra/terraform/aws/envs/stg` | Staging S3 + CloudFront + OIDC deploy / plan roles |
| `infra/terraform/aws/envs/prod` | Production S3 + CloudFront + deploy role |
| `infra/terraform/cloudflare` | DNS CNAMEs only (`fuboot` / `fuboot-stg`) |
| `infra/terraform/grafana` | App folder, dual-env dashboards, synthetics, GitHub DS |

CI runs **plan only** — apply locally (`AWS_PROFILE=7oas7er`).

## Edge gate (platform shared-edge)

CloudFront origin-verify Function rejects requests missing `X-Origin-Verify`. Cloudflare must inject that header via platform `shared-edge` **before** enabling the gate in AWS (or the site returns 403 for everyone).

Frank must:

1. Put matching secrets in **platform** `infra/terraform/shared-edge/terraform.tfvars` (`fuboot_stg_origin_verify_secret`, `fuboot_prod_origin_verify_secret`) — never commit real values.
2. `terraform apply` platform shared-edge (origin-verify + respect-origin cache for the two hosts).
3. Apply app AWS envs with the **same** secrets in each env’s tfvars.
4. Then apply app Cloudflare DNS + Grafana.

See ADRs `0005`, `0007` and `infra/terraform/docs/origin-verify-secret-rotation.md`.

## Request path

Browser → Cloudflare (custom domain) → inject `X-Origin-Verify` → CloudFront → S3. Direct CloudFront URLs return 403. No `/api/*`.

## Observability

Grafana Cloud Free only. Dashboards: `fuboot-tours-prod.json` / `fuboot-tours-stg.json` (regenerate via `infra/terraform/grafana/scripts/generate-env-dashboards.py`). Synthetics probe `/`, `/vrml/play-opensea.html`, and `/vrml/harbour/play.html`. Infinity DS + GitHub plugin live in platform shared-obs; this app wires zoneTag + `github-fuboot-tours` DS.

## Delivery

Feature PRs → `staging` (AWS stg). Promote `staging` → `main` (AWS prod) only when asked. Deploy workflow syncs `site/` via OIDC.
