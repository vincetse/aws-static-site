output "lambda_function_arn" {
  value = "${aws_lambda_function.lambda_pkg.qualified_arn}"
}
