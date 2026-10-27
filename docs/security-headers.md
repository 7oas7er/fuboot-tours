# Security headers — FUBoot Tours

| Layer | Role |
|-------|------|
| **CloudFront** `aws_cloudfront_response_headers_policy.site` | **Source of truth** for viewer security headers (CSP, HSTS, Referrer-Policy, X-Frame-Options, X-Content-Type-Options, Permissions-Policy, COOP, CORP). Attached to the default S3 behavior. Also removes `x-amzn-trace-id` and legacy `x-xss-protection`. |
| **CloudFront Function** `origin_verify` (viewer-request) | Rejects requests without a valid `X-Origin-Verify` header (Cloudflare injects via platform shared-edge). |
| **Cloudflare** | DNS + cache respect-origin + origin-verify injection only — does **not** duplicate these HTTP security headers. |

## CSP notes

Play pages load X_ITE from `cdn.jsdelivr.net` and use inline `<script>` / `<style>`. The CloudFront CSP therefore allows:

- `script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net`
- `style-src 'self' 'unsafe-inline'`
- `connect-src` / `worker-src` / `child-src` for jsDelivr + `blob:` as needed by X_ITE

There is no `/api/scores` behavior and no `strip_aws_headers` Function.

## Verify

1. After deploy, hard-refresh `https://fuboot-stg.7oas7er.com/` and check DevTools → Network → response headers (and console for CSP violations).
2. Confirm a direct CloudFront URL without the verify header returns 403.
