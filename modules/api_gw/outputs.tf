output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "api_gateway_invoke_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}${aws_api_gateway_rest_api.api.id}/prod"
}
