# Lambda role policy.
data "aws_iam_policy_document" "role_policy" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            identifiers = ["lambda.amazonaws.com"]
            type = "Service"
        }
    }
}

# Attach policy to role.
resource "aws_iam_role" "lambda_role" {
    name = "terraform_aws_lambda_role"
    assume_role_policy = "${data.aws_iam_policy_document.role_policy.json}"
}

# Attach SNS policy access
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "${aws_iam_policy.sns_policy.arn}"
    depends_on = [aws_iam_policy.sns_policy]
}

# Create ZIP File.

data "archive_file" "zip_the_python_code" {
    type        = "zip"
    source_dir  = "${path.module}/function/"
    output_path = "${path.module}/function/lambda_function.zip"
}

# Create Lambda function.

resource "aws_lambda_function" "calculate_sum" {
    function_name = "calculate-sum"
    filename = "${path.module}/function/lambda_function.zip"
    role = "${aws_iam_role.lambda_role.arn}"
    handler  = "lambda_function.lambda_handler"
    runtime  = "python3.11"
    depends_on = [aws_sns_topic.sns_topic]

    environment {
        variables = {
        snsTopicArn = "${aws_sns_topic.sns_topic.arn}"
    }
  }
}

# Add API Gateway permissions
resource "aws_lambda_permission" "api_gateway_permissions" {
    statement_id  = "APIGateWayInvoke"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.calculate_sum.function_name}"
    principal     = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.calculate_sum_api.execution_arn}/*/${aws_api_gateway_method.get_method_for_calculate.http_method}/${aws_api_gateway_resource.calculate_path.path_part}"
    depends_on = [aws_lambda_function.calculate_sum, aws_api_gateway_rest_api.calculate_sum_api]
}