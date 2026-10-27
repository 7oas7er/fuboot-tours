# Agent definition of done — FUBoot Tours

Instructions for Cursor (and similar) agents in this repo. Security floor: [`docs/github-branch-protection.md`](docs/github-branch-protection.md). Secrets: [`SECURITY.md`](SECURITY.md). Architecture: [`docs/architecture.md`](docs/architecture.md).

## What this repo is

Public archive of the FU Berlin *Webbasierte 3D* FUBoot Tours VRML mini-game, with X_ITE players under `site/`. Hosted on AWS (S3 + CloudFront) behind Cloudflare DNS + platform shared-edge — same pattern as Block Drop / Netrunner. **No high-scores API / Lambda.**

## Defaults

- Prefer **small diffs** that match existing patterns. No drive-by refactors outside the task.
- Keep playability via static files + [`serve-xite.py`](serve-xite.py) (serves `site/` by default); do not add a bundler/framework unless Frank asks.
- Do **not** invent a second monitoring SaaS or CI `terraform apply` — follow the Block Drop / platform pattern.
- Public deploy tree is **`site/`** only. Do not ship `addon/`, `dokumentation/`, `reports/`, `research_notes/`, or `*.corrupt.bak` into S3.

## GitHub workflow

- Feature work: branch → PR → **`staging`**.
- Production: PR **`staging` → `main`** only when asked to promote.
- Do **not** push or merge unless Frank asks. Do **not** force-push protected branches.
- Create commits only when asked.
- **Security floor** (Dependabot alerts, secret scanning + push protection, ruleset, default branch `main`, read-only `GITHUB_TOKEN`): apply and API-verify per [`docs/github-branch-protection.md`](docs/github-branch-protection.md) — copying files is not enough.
- **Actions pins**: every workflow `uses:` is a full 40-char SHA with a version comment ([`docs/github-actions-pinning.md`](docs/github-actions-pinning.md)).

## Terraform / edge

- Apply locally (`AWS_PROFILE=7oas7er`); CI is plan-only.
- Platform shared-edge secrets + apply **before** enabling CloudFront origin-verify (see `docs/architecture.md`).
- Never commit `terraform.tfvars`, `.tfstate`, or tokens.

## Definition of done

1. [ ] Change matches the request; no unrelated refactors.
2. [ ] No secrets staged.
3. [ ] If asked for a PR: target **`staging`** unless Frank asked for a promote-to-`main` PR.
4. [ ] Docs updated when operator steps change (README or this file).
