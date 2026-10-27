# Account-wide GitHub OIDC provider (created by the first app / Block Drop).
# Do not create a second provider — AWS allows only one URL per account.
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}
