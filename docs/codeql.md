# CodeQL — FUBoot Tours

In-repo advanced CodeQL (`.github/workflows/codeql.yml` + `.github/codeql/codeql-config.yml`). Keep GitHub **default** CodeQL setup **off** (see `docs/github-branch-protection.md`).

| Language | Paths |
|----------|--------|
| `javascript-typescript` | `site/**` (play HTML/JS); ignore markdown / lockfiles / terraform |
| `actions` | `.github/workflows/**` |

Triage new alerts on `staging` before promoting. No Lambda package in this repo.
