# GitHub branch protection and security floor

Target branches: **`staging`** and **`main`**. Default branch must be **`main`**.

**Hard rule:** copying workflows / docs does **not** configure GitHub. Apply Settings and rulesets with `gh` and **verify via API**. Pattern copied from [`7oas7er/block-drop`](https://github.com/7oas7er/block-drop) `docs/github-branch-protection.md`.

## Hard-required check

| Check name | Workflow | Why |
|------------|----------|-----|
| `Required CI` | [`.github/workflows/required-ci.yml`](../.github/workflows/required-ci.yml) | Always reports on PRs to `staging`/`main`; runs the Actions SHA-pin check ([`docs/github-actions-pinning.md`](github-actions-pinning.md)) |

## Ruleset settings

One ruleset covering `refs/heads/staging` and `refs/heads/main`:

1. **Restrict deletions** — on
2. **Block force pushes** — on
3. **Require a pull request before merging** — on (0 approvals while solo)
4. **Require status checks to pass** — on, context **`Required CI`** only

## Repo security floor

| Control | Expected |
|---------|----------|
| Default branch | **`main`** |
| Dependabot **alerts** | **Enabled** |
| Secret scanning | **Enabled** |
| Push protection | **Enabled** |
| CodeQL **default** setup | **Off** (`not-configured`) |
| Branch ruleset `default` | **Active** on `main` + `staging` |
| Actions `GITHUB_TOKEN` | **Read**; cannot approve PRs |
| Issues / Wiki / Projects | **Off** |

Leave **off** unless opting in: Dependabot security updates, secret-scanning validity checks, non-provider patterns.

## Apply / verify via `gh`

```bash
REPO=7oas7er/fuboot-tours

gh api -X PUT "repos/$REPO/vulnerability-alerts"

gh api -X PATCH "repos/$REPO" --input - <<'EOF'
{
  "security_and_analysis": {
    "secret_scanning": { "status": "enabled" },
    "secret_scanning_push_protection": { "status": "enabled" }
  }
}
EOF

gh api -X PUT "repos/$REPO/actions/permissions/workflow" \
  -f default_workflow_permissions=read \
  -F can_approve_pull_request_reviews=false

gh api -X PATCH "repos/$REPO" -F has_issues=false -F has_wiki=false -F has_projects=false -f default_branch=main

# Ruleset — create once after Required CI has run on a PR:
gh api -X POST "repos/$REPO/rulesets" --input - <<'EOF'
{
  "name": "default",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "exclude": [],
      "include": ["refs/heads/main", "refs/heads/staging"]
    }
  },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "required_reviewers": [],
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false,
        "require_extra_approval_for_unattributed_changes": true,
        "allowed_merge_methods": ["merge", "squash", "rebase"]
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": false,
        "do_not_enforce_on_create": false,
        "required_status_checks": [{ "context": "Required CI" }]
      }
    }
  ],
  "bypass_actors": []
}
EOF
```

### Verify

```bash
REPO=7oas7er/fuboot-tours
gh api "repos/$REPO" --jq '{default_branch, security_and_analysis, has_issues, has_wiki, has_projects}'
gh api -i "repos/$REPO/vulnerability-alerts" | head -n 1   # expect 204
gh api "repos/$REPO/actions/permissions/workflow"
gh api "repos/$REPO/code-scanning/default-setup" --jq .state   # expect not-configured
gh api "repos/$REPO/rulesets" --jq '.[] | {id,name,enforcement}'
```
