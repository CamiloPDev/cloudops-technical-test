resource "aws_apigatewayv2_api" "main" {
  name          = var.api_name
  protocol_type = "HTTP"
  description   = var.description

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
    max_age       = 300
  }

  tags = var.tags
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/aws/apigateway/${var.api_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_apigatewayv2_integration" "lambda" {
  count = var.enable_lambda_integration ? 1 : 0

  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_function_invoke_arn
  integration_method        = "POST"
  payload_format_version    = "2.0"
  timeout_milliseconds      = 30000
}

resource "aws_apigatewayv2_route" "lambda" {
  count = var.enable_lambda_integration ? 1 : 0

  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /lambda/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda[0].id}"
}

resource "aws_lambda_permission" "api_gateway" {
  count = var.enable_lambda_integration ? 1 : 0

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "alb" {
  count = var.enable_alb_integration ? 1 : 0

  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "HTTP_PROXY"
  integration_uri  = var.alb_dns_name
  integration_method        = "ANY"
  connection_type           = "INTERNET"
  payload_format_version    = "1.0"
  timeout_milliseconds      = 30000
}

resource "aws_apigatewayv2_route" "alb" {
  count = var.enable_alb_integration ? 1 : 0

  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.alb[0].id}"
}

resource "aws_apigatewayv2_domain_name" "main" {
  count = var.custom_domain_name != "" ? 1 : 0

  domain_name = var.custom_domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
}

resource "aws_apigatewayv2_api_mapping" "main" {
  count = var.custom_domain_name != "" ? 1 : 0

  api_id      = aws_apigatewayv2_api.main.id
  domain_name = aws_apigatewayv2_domain_name.main[0].id
  stage       = aws_apigatewayv2_stage.main.id
}
