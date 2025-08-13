resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0484194c9fd83f3e7"  
  instance_type = "t2.micro"  # Adjust as needed
  key_name      = var.key_name  # Ensure you have a valid key pair

    subnet_id     = var.public_subnet_ids[0] 
     # Use the first public subnet for this instance
     # Ensure you have a security group defined
    vpc_security_group_ids = [aws_security_group.new_security_group.id]  # Use the security group defined above
    associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.cw_agent_profile.name
    user_data = templatefile("${path.module}/userdata.tpl", {
    LOG_GROUP_SYSTEM = aws_cloudwatch_log_group.ec2_syslog.name
    REGION           = "us-east-1"
  })

  tags = {
    Name = "MyEC2Instance"
  }
  
}

resource "aws_security_group" "new_security_group" {
  name        = "my_ec2_sg"
  description = "Security group for my EC2 instance"
  vpc_id      = var.vpc_id

  # SSH (tighten later to your /32)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # No inbound 443 needed for CloudWatch/Datadog
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}