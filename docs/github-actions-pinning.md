# GitHub Actions — SHA pinning

Every `uses:` in `.github/workflows/` must pin to a **full 40-character commit SHA**,
with the human version in a trailing comment:

```yaml
uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
```

Mutable tags (`@v4`, `@v7.0.1`) are not allowed.

## Automation

| Piece | Role |
|-------|------|
| [`.github/dependabot.yml`](../.github/dependabot.yml) `github-actions` | Weekly PRs → `staging` |
| [`.github/scripts/check-github-action-pins.sh`](../.github/scripts/check-github-action-pins.sh) | Fails CI on unpinned refs |
| [Required CI](../.github/workflows/required-ci.yml) | Runs the pin check on every PR to `staging` / `main` |

Local check:

```bash
.github/scripts/check-github-action-pins.sh
```
