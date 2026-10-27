# Security

## Reporting

Public archive of a ~2003 FU Berlin VRML course project plus modern X_ITE players and static hosting. If you find a vulnerability in the published site or repo tooling:

1. Contact Frank (repo owner) directly — do not open a public issue with exploit detail.
2. Include impact and safe reproduction steps if possible.

There is no bug bounty.

## Secrets — never commit

Do not commit API tokens, AWS keys, Cloudflare tokens, Grafana tokens, `.tfstate`, or `terraform.tfvars`. Prefer gitignored tfvars, GitHub Environment secrets/vars, or shell env vars (`AWS_PROFILE=7oas7er`).

Origin-verify secrets must match between app AWS env tfvars and platform `shared-edge` tfvars — still never commit the real values.

## Related

- Architecture / edge gate: [`docs/architecture.md`](docs/architecture.md)
- Branch protection / CI gates: [`docs/github-branch-protection.md`](docs/github-branch-protection.md)
- Actions SHA pinning: [`docs/github-actions-pinning.md`](docs/github-actions-pinning.md)
- Security headers: [`docs/security-headers.md`](docs/security-headers.md)
