locals {
    # Constants
    event_notification_id           = "${var.lambda.function_name}-notifications"
    event_notification_arn          = "arn:aws:sns:*:*:${local.event_notification_id}"
        # note: construct lambda arn before to prevent dependency cycles, i.e.
            # notification_policy(lambda) -> lambda(sns) -> sns(notification_policy)
            #  -> ad infinitum.
    formatted_function_name         = replace(replace(var.lambda.function_name, "/", "-"), var.namespace, "")
    lambda_arn                      = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.lambda.function_name}:*"
    
    # Calculations
    conditions                      = {
        provision_key               = var.lambda.key == null
    }
    # Configurations
    encryption_configuration        = local.conditions.provision_key ? (
                                        module.kms[0].key 
                                    ) : (
                                        var.lambda.key
                                    )
    environment_configuration       = try(var.lambda.environment_variables, {})
    vpc_configuration               = try(var.lambda.vpc_config, {})
}