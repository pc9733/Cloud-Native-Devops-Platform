# Create an EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0484194c9fd83f3e7"  # Amazon Machine Image ID
  instance_type = "t2.micro"                # Instance type (adjust as needed)
  key_name      = var.key_name              # SSH key pair name

  subnet_id     = var.public_subnet_ids[0]  # Use the first public subnet
  vpc_security_group_ids = [aws_security_group.new_security_group.id]  # Attach the security group defined 
  associate_public_ip_address = true        # Assign a public IP address, important for SSH access without a NAT gateway

  iam_instance_profile = aws_iam_instance_profile.cw_agent_profile.name  # Attach IAM instance profile for CloudWatch agent

  # Pass user data script using a template file
  user_data = templatefile("${path.module}/userdata.tpl", {
    LOG_GROUP_SYSTEM = aws_cloudwatch_log_group.ec2_syslog.name
    REGION           = "us-east-1"
  })

  tags = {
    Name = "MyEC2Instance"   
    Role = "backend"        # Tag the instance
  }

  lifecycle {
    create_before_destroy = true            # Create new instance before destroying old one
    prevent_destroy       = false           # Allow destroy
    ignore_changes        = [user_data]     # Ignore changes to user_data after creation
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


# The following resource is commented out and not currently in use.
# It creates two EC2 instances if var.instance is true, otherwise none.
# resource "aws_instance" "my_ec2_instance-1" {
#
#   ami           = "ami-06eac51adcd9dc8d6"  # Amazon Machine Image ID for this instance
#   count         =  var.instance ? 2 : 0      # Number of instances to create based on var.instance
#   instance_type = "t3.micro"                # Instance type (adjust as needed)
#   key_name      = var.key_name              # SSH key pair name
#
#   # Use the first public subnet for this instance
#   subnet_id     = var.public_subnet_ids[0]  
#
#   # Attach the security group defined above
#   vpc_security_group_ids = [aws_security_group.new_security_group.id]  
#
#   tags = {
#     Name = "test-1.${count.index + 1}"     # Tag the instance with a unique name
#   }
#
# }