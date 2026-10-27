# CloudFront distribution metrics live in us-east-1.

resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx" {
  # CloudFront standard metrics are published only in us-east-1.
  region = "us-east-1"

  alarm_name          = local.cloudfront_5xx_alarm_name
  alarm_description   = "CloudFront 5xx error rate exceeded threshold."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  threshold           = 5
  treat_missing_data  = "notBreaching"

  metric_name = "5xxErrorRate"
  namespace   = "AWS/CloudFront"
  period      = 60
  statistic   = "Average"
  unit        = "Percent"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.site.id
    Region         = "Global"
  }

  tags = {
    Name = local.cloudfront_5xx_alarm_name
  }
}
