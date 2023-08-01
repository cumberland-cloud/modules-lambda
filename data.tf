data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "notification_resource_policy" {
  statement {
        sid                     = "LambdaServicePerms"
        effect                  = "Allow"
        actions                 = [ "sns:Publish"]
        resources               = [ local.event_notification_arn ]

        condition {
            test                = "ArnLike"
            variable            = "aws:SourceArn"
            values              = [ local.lambda_arn ]
        }

        principals {
            type                = "*"
            identifiers         = [ "*" ]
        }
    }
}

data "aws_iam_policy_document" "notification_identity_policy" {
  statement {
        effect                  = "Allow"
        actions                 = [ "sns:Publish"]
        resources               = [ local.event_notification_arn ]

        condition {
            test                = "ArnLike"
            variable            = "aws:SourceArn"
            values              = aws_lambda_function.this.arn
        }

        principals {
            type                = "*"
            identifiers         = [ "*" ]
        }
    }
}