# FUBoot Tours

VRML mini-game from a Freie Universität Berlin course (*Webbasierte 3D-Anwendungsentwicklung*, ca. 2003): steer a submarine through a virtual sea around the former Soviet submarine harbour of Murmansk.

**Hosts:** [fuboot.7oas7er.com](https://fuboot.7oas7er.com) (prod) · [fuboot-stg.7oas7er.com](https://fuboot-stg.7oas7er.com) (stg)  
**Public tree:** `site/` (landing + `site/vrml/`)

## Play with X_ITE (localhost)

```bash
python3 serve-xite.py
```

Serves `site/` by default:

- Landing: http://127.0.0.1:8765/
- Open sea: http://127.0.0.1:8765/vrml/play-opensea.html
- Harbour: http://127.0.0.1:8765/vrml/harbour/play.html

On the open sea, hover the left strip for forward/back speed and the circular pad for turn + dive/rise; click the pad to lock/unlock course.

## Contents

| Path | Description |
|------|-------------|
| `site/index.html` | Hosted landing (links to play pages) |
| `site/vrml/` | Playable VRML + X_ITE HTML (deployed) |
| `vrml/` | Working copy at repo root (archive / edit source; sync into `site/vrml` when shipping) |
| `serve-xite.py` | Local static server (MIME types for `.wrl` / `.x3d`) |
| `infra/terraform/` | AWS / Cloudflare DNS / Grafana (Block Drop pattern) |
| `dokumentation/` | Course documentation (Word) — not deployed |
| `addon/` | Historical tooling notes — not deployed |

## Hosting (operators)

See [`docs/architecture.md`](docs/architecture.md). Apply order sketch: bootstrap state → AWS stg → platform shared-edge (secrets) → Cloudflare DNS → Grafana → AWS prod when promoting.

Smoke tests: `cd tests && npm test`

## Agents / security

- [`AGENTS.md`](AGENTS.md) — agent workflow (PRs → `staging`)
- [`SECURITY.md`](SECURITY.md) — reporting and secrets
- [`docs/github-branch-protection.md`](docs/github-branch-protection.md) — GitHub security floor

## Authors

Andreas Gramm, Philipp Heroven, Oliver Kudell, Frank Schlesinger — Fachbereich Informatik, Freie Universität Berlin.
