resource "aws_lambda_function" "mark_overdue_tasks" {
  function_name = "mark-overdue-tasks"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      SECRET_NAME = "mydb-credentials-1.2"
      DB_HOST     = var.db_host
      DB_PORT     = tostring(var.db_port)
      DB_NAME     = var.db_name
    }
  }

  memory_size = 256
  timeout     = 15
}