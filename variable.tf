variable "lambda" {
    description                         = <<EOT
    Lambda function configuration object.
        
    KMS key: If no KMS key is specified for the encryption of resources, one will be provisioned. If using a pre-existing key, the key output from the KMS module should be passed in under the `key` object.

    Execution_role: Pass in the `service_roles['lambda']` output from the IAM module.
    EOT
    type                                = object({
        execution_role                  = any
        function_name                   = string
        image_url                       = string
        environment_variables           = optional(map(any), null)
        key                             = optional(string, null)
        memory                          = optional(number, 512)
        timeout                         = optional(number, 120)
        tracing_config_mode             = optional(string, "Active")
        reserved_concurrent_executions  = optional(number, 50)
        vpc_config                      = optional(object({
            security_group_ids          = list(string)
            subnet_ids                  = list(string)
        }), null)
    })
}

variable "namespace" {
    type                                = string
    description                         = "Root namespace of resources"
    default                             = "cumberland-cloud"
}