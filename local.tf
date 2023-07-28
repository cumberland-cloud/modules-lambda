locals {
    # Constants
    event_notification_id           = "${var.lambda.function_name}-notifications"
    event_notification_arn          = "arn:aws:sns:*:*:${local.event_notification_id}"
    # Calculations
    conditions                      = {
        provision_key               = var.lambda.key == null
    }
    # Configurations
    encryption_configuration        = local.conditions.provision_key ? (
                                        module.kms[0].key 
                                    ) : (
                                        var.bucket.key
                                    )
    environment_configuration       = try(var.lambda.environment_variables, {})
    vpc_configuration               = try(var.lambda.vpc_config, {})
}