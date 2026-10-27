resource "aws_iam_role" "github_deploy" {
  name               = local.github_deploy_role_name
  description        = "GitHub Actions publishes FUBoot Tours (${var.environment}) and invalidates CloudFront."
  assume_role_policy = data.aws_iam_policy_document.github_deploy_assume_role.json

  tags = {
    Name = local.github_deploy_role_name
  }
}

resource "aws_iam_role_policy" "github_deploy" {
  name   = local.github_deploy_policy_name
  role   = aws_iam_role.github_deploy.id
  policy = data.aws_iam_policy_document.github_deploy.json
}
