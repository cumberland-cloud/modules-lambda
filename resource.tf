resource "aws_lambda_function" "this" {
    #checkov:skip=CKV_AWS_272: "Ensure AWS Lambda function is configured to validate code-signing"
        # TODO: sign ECR images

    function_name                   = var.lambda.function_name
    image_uri                       = var.lambda.image_url
    kms_key_arn                     = local.encryption_configuration.arn
    memory_size                     = var.lambda.memory
    package_type                    = "Image"
    publish                         = true
    role_arn                        = var.lambda.execution_role.arn
    timeout                         = var.lambda.timeout
    reserved_concurrent_executions  = var.lambda.reserved_concurrent_executions
    
    dead_letter_config {
        target_arn                  = aws_sns_topic.this.arn
    }

    tracing_config {
        mode                        = var.lambda.tracing_config_mode
    }

    dynamic "environment" {
        for_each                    = local.environment_configuration

        content {
            variables               = var.lambda.environment_variables
        }
    }

    dynamic "vpc_config" {
        for_each                    = local.vpc_configuration

        content {
            subnet_ids              = var.lambda.vpc_config.subnet_ids
            security_group_ids      = var.lambda.vpc_config.security_group_ids
        }
    }
}

resource "aws_cloudwatch_log_group" "this" {
    #checkov:skip=CKV_AWS_338: "Ensure CloudWatch log groups retains logs for at least 1 year"
        # NOTE: checkov's a golddigger
    kms_key_id                      = local.encryption_configuration.arn
    name                            = "/aws/lambda/${var.lambda.function_name}"
    retention_in_days               = 14
}


resource "aws_sns_topic" "this" {
    kms_master_key_id               = local.encryption_configuration.alias_arn
    name                            = local.event_notification_id
    policy                          = data.aws_iam_policy_document.notification_resource_policy.json
}

resource "aws_iam_policy" "this" {
  name                              = "${local.formatted_function_name}-sns-dlq-policy"
  description                       = "Allows publishing to the SNS Topic '${local.event_notification_id}'"
  policy                            = data.aws_iam_policy_document.notification_identity_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role                              = var.lambda.execution_role.name
  policy_arn                        = aws_iam_policy.this.arn
}