locals {
    vpc_map                     = try({
        vpc_config              = var.lambda.vpc_config
    }, {})
    env_map                     = try({
        environment_variables   = var.lambda.environment_variables
    }, {})
}