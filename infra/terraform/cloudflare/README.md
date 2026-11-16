# Cloudflare — FUBoot Tours (DNS only)

Manages DNS for `fuboot.7oas7er.com` and `fuboot-stg.7oas7er.com` on zone `7oas7er.com`.

Does **not** manage zone apex or `www` (homepage owns `www`; apex → `www` redirect lives in platform `shared-edge`).

**Zone rulesets** (origin-verify, cache, apex redirects, SSL mode (and sibling-app rate limits)) are owned by the platform repo:

https://github.com/7oas7er/platform → `infra/terraform/shared-edge`

Do not recreate competing zone rulesets here (Cloudflare allows one ruleset per phase).

```bash
export AWS_PROFILE=7oas7er
export CLOUDFLARE_API_TOKEN=…   # Zone.DNS Edit + Zone.Read (+ Cache Purge for deploy)
cd infra/terraform/cloudflare
terraform init && terraform apply
```
