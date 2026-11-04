# FUBoot Tours

VRML mini-game from a Freie Universität Berlin course (*Webbasierte 3D-Anwendungsentwicklung*, ca. 2003): steer a submarine through a virtual sea around the former Soviet submarine harbour of Murmansk. Public static archive + X_ITE play pages, plus the **app-owned** AWS / DNS / Grafana stack.

**Fundamental design:** each app is an **isolated repository**. Shared Cloudflare zone rulesets and shared Grafana Free objects (Infinity DS, GitHub plugin) live in [`7oas7er/platform`](https://github.com/7oas7er/platform). Apps depend on platform — **never on each other**. **No high-scores API / Lambda.**

- **Architecture:** [`docs/architecture.md`](docs/architecture.md)
- **ADRs:** [`docs/adr/`](docs/adr/)
- **Agents:** [`AGENTS.md`](AGENTS.md)
- **Secrets:** [`SECURITY.md`](SECURITY.md)
- **Security floor:** [`docs/github-branch-protection.md`](docs/github-branch-protection.md)
- **Maintenance:** [`docs/maintenance.md`](docs/maintenance.md)
- **Dashboard template:** [`docs/grafana-dashboard-template.md`](docs/grafana-dashboard-template.md)

**Hosts:** [fuboot.7oas7er.com](https://fuboot.7oas7er.com) (prod) · [fuboot-stg.7oas7er.com](https://fuboot-stg.7oas7er.com) (stg)

## Layout

| Path | Role |
|------|------|
| [`site/`](site/) | Public deploy tree — landing + `site/vrml/` (no framework, bundler, or build step) |
| [`vrml/`](vrml/) | Working copy at repo root (archive / edit source; sync into `site/vrml` when shipping) |
| [`serve-xite.py`](serve-xite.py) | Local static server (MIME types for `.wrl` / `.x3d`) |
| [`tests/`](tests/) | Node unit smoke tests; gates deploy |
| [`infra/terraform/aws/`](infra/terraform/aws/) | Site module + `envs/stg` / `envs/prod` + bootstrap |
| [`infra/terraform/cloudflare/`](infra/terraform/cloudflare/) | **DNS only** for FUBoot hosts (zone rulesets → platform `shared-edge`) |
| [`infra/terraform/grafana/`](infra/terraform/grafana/) | App synthetics, CloudWatch, **prod+stg** dashboards, GitHub DS (Infinity + plugin → platform `shared-obs`; layout [`docs/grafana-dashboard-template.md`](docs/grafana-dashboard-template.md)) |
| [`infra/lambda/`](infra/lambda/) | N/A — static archive only (no API package) |
| [`dokumentation/`](dokumentation/) | Course documentation (Word) — not deployed |
| [`addon/`](addon/) | Historical tooling notes — not deployed |
| [`.cursor/rules/`](.cursor/rules/) | Platform (`app-*`) + product (`fuboot-tours-*`) Cursor rules — see [`.cursor/rules/README.md`](.cursor/rules/README.md) |
| [`AGENTS.md`](AGENTS.md) | Definition of done for AI-assisted changes |
| [`docs/architecture.md`](docs/architecture.md) | App vs shared-platform ownership |
| [`docs/`](docs/) | ADRs, ops docs, cross-cutting docs |
| [`docs/maintenance.md`](docs/maintenance.md) | Ongoing patch / Dependabot cadence |
| [`SECURITY.md`](SECURITY.md) | Reporting + secret leak / rotation pointers |

## Environments and promotion

| Env | Domain |
|-----|--------|
| stg | `fuboot-stg.7oas7er.com` |
| prod | `fuboot.7oas7er.com` |

- Feature work → PR into **`staging`** → deploys **AWS stg** only.
- Promote to production by merging **`staging` → `main`** → deploys **AWS prod**.
- GitHub Environments `staging` / `production` / `terraform` hold distinct deploy/plan roles, buckets, and distributions. Do not point staging and production at the same resources.

## CI / CD

| Workflow | What it does |
|----------|----------------|
| [`.github/workflows/deploy-fuboot-tours.yml`](.github/workflows/deploy-fuboot-tours.yml) | Unit smoke tests; on push to `staging`/`main`, syncs `site/` to S3, invalidates CloudFront, purges Cloudflare (when site paths change) |
| [`.github/workflows/terraform-plan.yml`](.github/workflows/terraform-plan.yml) | `fmt` / **Checkov** / `validate` / **plan** for changed Terraform roots (OIDC read-only plan role). **Never applies.** |
| [`.github/workflows/dependency-audit.yml`](.github/workflows/dependency-audit.yml) | `npm audit --audit-level=high` for `tests/` when that lockfile changes |
| [`.github/workflows/required-ci.yml`](.github/workflows/required-ci.yml) | Always-on PR check (`Required CI`) for branch rulesets |
| [`.github/workflows/codeql.yml`](.github/workflows/codeql.yml) | CodeQL SAST for `site/` and Actions workflows |

Deploy auth is GitHub OIDC → env-specific IAM roles (no long-lived AWS keys in GitHub). Dependabot opens weekly PRs to `staging` for Actions, `tests/` npm, and **Terraform providers** (per root). Ongoing cadence: [`docs/maintenance.md`](docs/maintenance.md). Branch rules: [`docs/github-branch-protection.md`](docs/github-branch-protection.md). Action SHA pins: [`docs/github-actions-pinning.md`](docs/github-actions-pinning.md). Checkov: [`docs/iac-policy.md`](docs/iac-policy.md). CodeQL: [`docs/codeql.md`](docs/codeql.md). Security headers: [`docs/security-headers.md`](docs/security-headers.md).

## Terraform (local apply)

Apply stays on your machine. Typical profile:

```bash
export AWS_PROFILE=7oas7er
```

Roots (separate state keys under `shared-fuboot-tours-terraform-state-bucket`):

- `infra/terraform/aws/bootstrap`
- `infra/terraform/aws/envs/stg` and `envs/prod`
- `infra/terraform/cloudflare` (DNS)
- `infra/terraform/grafana` (app dashboards / synthetics / CW / GitHub DS)

Plus platform roots (separate repo / state): `shared-edge`, `shared-obs` — see [`7oas7er/platform`](https://github.com/7oas7er/platform).

Typical first-apply order: bootstrap → `aws/envs/stg` → platform `shared-edge` (FUBoot origin-verify secrets) → Cloudflare DNS → Grafana → prod when promoting. See [`docs/architecture.md`](docs/architecture.md).

Never commit `.tfstate`, `terraform.tfvars`, API tokens, or AWS keys. Setup notes:

- [Architecture](docs/architecture.md)
- [Terraform plan CI](infra/terraform/docs/terraform-plan-ci.md)
- [Origin-verify secret rotation](infra/terraform/docs/origin-verify-secret-rotation.md)
- [AWS README](infra/terraform/aws/README.md)
- [Cloudflare README](infra/terraform/cloudflare/README.md)
- [Grafana README](infra/terraform/grafana/README.md)

## Observability

**Grafana Cloud Free** only: synthetics, CloudWatch scrape, Cloudflare edge analytics (via GraphQL into Grafana), GitHub Actions panels. Do not add a second monitoring SaaS. Dual dashboards: FUBoot Tours — Production / Staging (`fuboot-tours-prod.json` / `fuboot-tours-stg.json`). Synthetics probe `/`, `/vrml/play-opensea.html`, and `/vrml/harbour/play.html`. Shared Infinity + GitHub plugin: platform `shared-obs` (app DS uid `github-fuboot-tours`). Label: `project=fuboot-tours`. Cloudflare remains DNS/edge (plus analytics pulled into Grafana)—not an APM product. Layout: [`docs/grafana-dashboard-template.md`](docs/grafana-dashboard-template.md).

## Security principles

- Public traffic must arrive via **Cloudflare**; direct CloudFront (or other origin) URLs are rejected (origin-verify header gate).
- Secrets live in gitignored tfvars, GitHub Environment secrets, or env vars—not in git.
- GitHub security floor (Dependabot alerts, secret scanning + push protection, ruleset on `main`/`staging`, read-only `GITHUB_TOKEN`, CodeQL default off): apply and API-verify per [`docs/github-branch-protection.md`](docs/github-branch-protection.md).
- Reporting and leak response: [`SECURITY.md`](SECURITY.md). Durable “why” for stack choices: [`docs/adr/`](docs/adr/).

## Local development

**Play with X_ITE:**

```bash
python3 serve-xite.py
```

Serves `site/` by default:

- Landing: http://127.0.0.1:8765/
- Open sea: http://127.0.0.1:8765/vrml/play-opensea.html
- Harbour: http://127.0.0.1:8765/vrml/harbour/play.html

On the open sea, hover the left strip for forward/back speed and the circular pad for turn + dive/rise; click the pad to lock/unlock course.

**Tests:**

```bash
cd tests
npm ci
npm test
```

**Pre-commit** (optional but recommended — catches `terraform fmt` and unit-test regressions before CI):

```bash
pipx install pre-commit   # or: brew install pre-commit
pre-commit install
pre-commit run --all-files
```

Config: [`.pre-commit-config.yaml`](.pre-commit-config.yaml). Hooks run `terraform fmt` under `infra/terraform/` and `npm run test:unit` when `tests/` or `site/` change. Full `terraform validate` stays in CI (needs init/backends).

## Working with Cursor / agents

Follow [`AGENTS.md`](AGENTS.md) and rules under [`.cursor/rules/`](.cursor/rules/) (`app-*` platform + `fuboot-tours-*` product). Decisions: [`docs/adr/`](docs/adr/). Public deploy tree is **`site/`** only — do not ship `addon/`, `dokumentation/`, `reports/`, `research_notes/`, or `*.corrupt.bak` into S3.

## Authors

Andreas Gramm, Philipp Heroven, Oliver Kudell, Frank Schlesinger — Fachbereich Informatik, Freie Universität Berlin.
