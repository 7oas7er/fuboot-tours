# Architecture decision records

Short “why” notes for irreversible or easy-to-re-litigate choices. Cursor rules (`.cursor/rules/` — platform `app-*` + product overlays) and [`AGENTS.md`](../../AGENTS.md) point agents at the norms; ADRs keep the reasoning durable.

## Rule of thumb

When you make a new **irreversible** (or expensive to reverse) choice — platform, apply model, observability product, traffic path, env promotion — add a ~½-page ADR here before or with the PR.

## Index

Copied from the Block Drop template where they still apply. Product-specific delivery (static VRML under `site/`, no API) is documented in [`../architecture.md`](../architecture.md).

| ADR | Title |
|-----|--------|
| [0003](0003-local-terraform-apply.md) | Local `terraform apply` (not CI apply) |
| [0005](0005-cloudflare-only-origin.md) | Cloudflare-only origin traffic |
| [0006](0006-github-env-separation.md) | GitHub Environment separation (`staging` / `production`) |
| [0007](0007-shared-edge-and-obs-platform.md) | Isolated apps + shared `7oas7er/platform` (edge + obs) |

Overall ownership: [`../architecture.md`](../architecture.md). Canonical platform ADR: [`7oas7er/platform` ADR 0001](https://github.com/7oas7er/platform/blob/main/docs/adr/0001-shared-edge-and-obs.md).
