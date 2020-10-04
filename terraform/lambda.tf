resource "aws_iam_role" "lambda" {
  name = "minecraft-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name        = "minecraft-lambda-policy"
  description = "Minecraft lambda policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-attach" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

data "archive_file" "lambda_zip_stop" {
  type        = "zip"
  source_dir  = "./lambda/stop_instances"
  output_path = "stop-instances.zip"
}

resource "aws_lambda_function" "stop_instances_lambda" {
  filename         = "stop-instances.zip"
  source_code_hash = data.archive_file.lambda_zip_stop.output_base64sha256
  function_name    = "stop-instances"
  role             = aws_iam_role.lambda.arn
  handler          = "main.lambda_handler"
  timeout          = 20
  runtime          = "python3.7"

  environment {
    variables = {
      EC2_ID = aws_instance.server.id
    }
  }
}

resource "aws_cloudwatch_event_rule" "daily" {
  name                = "daily"
  schedule_expression = "cron(0 21 ? * * *)"
}

resource "aws_cloudwatch_event_target" "run_lambda" {
  rule      = aws_cloudwatch_event_rule.daily.name
  target_id = "lambda"
  arn       = aws_lambda_function.stop_instances_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instances_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily.arn
}

### start instances ###

data "archive_file" "lambda_zip_start" {
  type        = "zip"
  source_dir  = "./lambda/start_instances"
  output_path = "start-instances.zip"
}

resource "aws_lambda_function" "start_instances_lambda" {
  filename         = "start-instances.zip"
  source_code_hash = data.archive_file.lambda_zip_start.output_base64sha256
  function_name    = "start-instances"
  role             = aws_iam_role.lambda.arn
  handler          = "main.lambda_handler"
  timeout          = 20
  runtime          = "python3.7"

  environment {
    variables = {
      EC2_ID = aws_instance.server.id
    }
  }
}

resource "aws_cloudwatch_event_rule" "start" {
  name                = "start"
  schedule_expression = "cron(0 17 ? * * 5-7)"
}

resource "aws_cloudwatch_event_target" "run_start_lambda" {
  rule      = aws_cloudwatch_event_rule.start.name
  target_id = "lambda"
  arn       = aws_lambda_function.start_instances_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_start" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_instances_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start.arn
}
