# Cursor rules — platform vs product

Rules split so this repo follows the **solo + AI** app template without Block Drop product names.

**Naming note:** Cursor `app-*` rules are the **in-repo platform pattern** (hosting, Grafana, Terraform habits). The **GitHub platform repository** [`7oas7er/platform`](https://github.com/7oas7er/platform) is separate: shared-edge + shared-obs that all apps consume. Do not conflate the two.

| Kind | Prefix | Role |
|------|--------|------|
| **App pattern** | `app-*` | Public web app in **one AWS account**, DNS-only Cloudflare in-app, Grafana-first, Terraform SoT; depends on `7oas7er/platform` for zone rulesets + shared Infinity/plugin |
| **Product** | `fuboot-tours-*` | This VRML archive only (static `site/`, domains, no API) |

Architecture: [`docs/architecture.md`](../../docs/architecture.md).

## Files

| Rule | Scope |
|------|--------|
| `app-core.mdc` | always — hosting, envs, secrets, Cloudflare-only, agents |
| `app-aws-regions.mdc` | always — `eu-north-1` default |
| `app-observability.mdc` | always — Grafana pattern (dual-env dashboards) |
| `app-terraform.mdc` | `infra/terraform/**` — roots, state, CI plan |
| `app-deploy.mdc` | `.github/workflows/**` — OIDC deploy / promote; Action SHA pins |
| `fuboot-tours-core.mdc` | always — product + pointers to platform |
| `fuboot-tours-frontend.mdc` | `site/**` |
| `fuboot-tours-terraform.mdc` | `infra/terraform/**` — naming, domains |
| `fuboot-tours-deploy.mdc` | `.github/workflows/**` — this app’s workflow |
| `fuboot-tours-observability.mdc` | always — this app’s labels / dashboard path |
