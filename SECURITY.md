# Security

## Reporting

This is a public archive of a ~2003 FU Berlin VRML course project plus modern X_ITE localhost players. If you find a vulnerability in the published site or repo tooling:

1. Contact Frank (repo owner) directly — do not open a public issue with exploit detail.
2. Include impact and safe reproduction steps if possible.

There is no bug bounty.

## Secrets — never commit

Do not commit API tokens, AWS keys, Cloudflare tokens, Grafana tokens, `.tfstate`, or `terraform.tfvars` if/when hosting infra is added. Prefer gitignored tfvars, GitHub Environment secrets, or shell env vars.

## Related

- Branch protection / CI gates: [`docs/github-branch-protection.md`](docs/github-branch-protection.md)
- Actions SHA pinning: [`docs/github-actions-pinning.md`](docs/github-actions-pinning.md)
