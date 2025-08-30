resource "aws_cloudwatch_event_rule" "daily_lambda_trigger" {
  name                = "daily-lambda-trigger"
  schedule_expression = "cron(0 0 * * ? *)" # midnight UTC
}

resource "aws_cloudwatch_event_target" "lambda_scheduled_target" {
  rule      = aws_cloudwatch_event_rule.daily_lambda_trigger.name
  target_id = "mark-overdue-lambda"
  arn       = aws_lambda_function.mark_overdue_tasks.arn
}

resource "aws_lambda_permission" "eventbridge_invoke_lambda" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mark_overdue_tasks.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_lambda_trigger.arn
}
