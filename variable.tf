variable "lambda" {
    description                 = "Lambda configuration. All lambdas are containerized."
    type                        = object({
        execution_role_arn      = string
        function_name           = string
        image_url               = string
        environment_variables   = optional(map(any), null)
        kms_key_arn             = optional(string, null)
        memory                  = optional(number, 512)
        timeout                 = optional(number, 120)
        vpc_config              = optional(object({
            security_group_ids  = list(string)
            subnet_ids          = list(string)
        }), null)
    })
}