resource "aws_lambda_function" "this" {
    function_name               = var.lambda.function_name
    image_uri                   = var.lambda.image_url
    kms_key_arn                 = var.lambda.kms_key_arn
    memory_size                 = var.lambda.memory
    package_type                = "Image"
    publish                     = true
    role_arn                    = var.lambda.execution_role_arn
    timeout                     = var.lambda.timeout

    dynamic "environment" {
        for_each                = local.env_map

        content {
            variables           = each.value.environment_variables
        }
    }

    dynamic "vpc_config" {
        for_each                = local.vpc_map

        content {
            subnet_ids          = each.value.vpc_config.subnet_ids
            security_group_ids  = each.value.vpc_config.security_group_ids
        }
    }
    environment {
        variables       = var.lambda.environment_variables
    }
}