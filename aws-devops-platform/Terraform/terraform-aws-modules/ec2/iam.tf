resource "aws_iam_role" "cw_agent_role" {
  name = "cw_agent_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "cw_agent_attach" {
  role       = aws_iam_role.cw_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cw_agent_profile" {
  name = "cw_agent_profile"
  role = aws_iam_role.cw_agent_role.name
}

resource "aws_cloudwatch_log_group" "ec2_syslog" {
  name              = "/ec2/${var.name}/system"
  retention_in_days = 14
}