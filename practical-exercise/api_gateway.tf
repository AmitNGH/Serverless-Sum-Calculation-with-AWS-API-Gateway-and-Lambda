## Creating API Gateway

# Create the gateway
resource "aws_api_gateway_rest_api" "calculate_sum_api" {
    name = "calculate-sum-api"
}

# Create /calculate path
resource "aws_api_gateway_resource" "calculate_path" {
    rest_api_id = "${aws_api_gateway_rest_api.calculate_sum_api.id}"
    parent_id   = "${aws_api_gateway_rest_api.calculate_sum_api.root_resource_id}"
    path_part = "calculate"
}

# Create get method handler
resource "aws_api_gateway_method" "get_method_for_calculate" {
    rest_api_id   = "${aws_api_gateway_rest_api.calculate_sum_api.id}"
    resource_id   = "${aws_api_gateway_resource.calculate_path.id}"
    http_method   = "GET"
    authorization = "NONE"
}

# Add lambda method to API Gateway
resource "aws_api_gateway_integration" "lambda_intigration" {
    rest_api_id   = "${aws_api_gateway_rest_api.calculate_sum_api.id}"
    resource_id   = "${aws_api_gateway_method.get_method_for_calculate.resource_id}"
    http_method = "${aws_api_gateway_method.get_method_for_calculate.http_method}"
    integration_http_method = "POST"
    content_handling = "CONVERT_TO_TEXT"
    type = "AWS_PROXY"
    uri = "${aws_lambda_function.calculate_sum.invoke_arn}"
    depends_on = [aws_lambda_function.calculate_sum, aws_api_gateway_method.get_method_for_calculate]
}

# Deploy gateway to allow access
resource "aws_api_gateway_deployment" "deploy_gateway" {
  depends_on = [aws_api_gateway_integration.lambda_intigration]
  rest_api_id = "${aws_api_gateway_rest_api.calculate_sum_api.id}"
  stage_name  = "dev"
}