# Security headers — FUBoot Tours

| Layer | Role |
|-------|------|
| **CloudFront** `aws_cloudfront_response_headers_policy.site` | **Source of truth** for viewer security headers (CSP, HSTS, Referrer-Policy, X-Frame-Options, X-Content-Type-Options, Permissions-Policy, COOP, CORP). Attached to the default S3 behavior. Also removes `x-amzn-trace-id` and legacy `x-xss-protection`. |
| **CloudFront Function** `origin_verify` (viewer-request) | Rejects requests without a valid `X-Origin-Verify` header (Cloudflare injects via platform shared-edge). |
| **Cloudflare** | DNS + cache respect-origin + origin-verify injection only — does **not** duplicate these HTTP security headers. |

## CSP notes

Play pages **self-host** X_ITE under `site/vendor/x_ite/` (same origin) and use inline `<script>` / `<style>`. Prefer `'self'` so a stale Cloudflare cache of an older CSP cannot blank the WebGL canvas again.

The CloudFront CSP still allows jsDelivr as a fallback:

- `script-src 'self' 'unsafe-inline' 'unsafe-eval' 'wasm-unsafe-eval' https://cdn.jsdelivr.net` (`unsafe-eval` for VRML `javascript:` Script nodes)
- `style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net` (required if the CDN build is used; without X_ITE CSS the canvas stays 1×1)
- `font-src` / `img-src` include jsDelivr for CDN fonts/assets
- `connect-src` / `worker-src` / `child-src` for jsDelivr + `blob:` as needed by X_ITE

After CSP or play-HTML changes: **purge Cloudflare** as well as CloudFront — CF can keep an old `Content-Security-Policy` header on a HIT long after the origin policy is updated.

There is no `/api/scores` behavior and no `strip_aws_headers` Function.

## Verify

1. After deploy, hard-refresh `https://fuboot-stg.7oas7er.com/` and check DevTools → Network → response headers (and console for CSP violations).
2. Confirm a direct CloudFront URL without the verify header returns 403.
