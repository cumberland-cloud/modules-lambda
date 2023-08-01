output "function" {
    value           = {
        arn         = aws_lambda_function.this.arn
        invoke_arn  = aws_lambda_function.this.invoke_arn
        name        = var.lambda.function_name
    }
}