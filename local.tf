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
    environment_configuration       = length(var.lambda.environment_variables) > 0 ? (
                                        toset(["placeholder"])
                                    ) : ( 
                                        toset([])
                                    )
    vpc_configuration               = length(var.lambda.vpc_config) > 0 ? (
                                        toset(["placeholder"])
                                    ) : ( 
                                        toset([])
                                    )
}