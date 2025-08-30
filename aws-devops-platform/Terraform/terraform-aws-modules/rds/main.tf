data "external" "lpass_rds_password" {
  program = ["./get_lpass_password.sh"]
}

resource "aws_db_subnet_group" "sb_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}

resource "aws_secretsmanager_secret" "db_secret" {
  name        = "mydb-credentials-1.2"
  description = "Credentials for MySQL DB"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
    secret_id     = aws_secretsmanager_secret.db_secret.id
    secret_string = jsonencode({
    username = "admin"
    password = data.external.lpass_rds_password.result["password"]
  })
}

resource "aws_kms_key" "db_encryption_key" {
  description             = "KMS key for encrypting RDS"
  deletion_window_in_days = 10
  enable_key_rotation     = true  # Enable automatic key rotation

  tags = {
    Name = "DBEncryptionKey"
  }
}

resource "aws_db_instance" "my_rds_instance" {
  instance_class           = "db.t3.micro"  # Adjust as needed
  allocated_storage        = 20
  storage_type             = "gp2"
  engine                   = "mysql"
  engine_version           = "8.0.42"
  username                 = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string)["username"]
  password                 = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string)["password"]
  backup_retention_period  = 7
  multi_az                 = true
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  db_subnet_group_name     = aws_db_subnet_group.sb_subnet_group.name
  publicly_accessible      = true
  storage_encrypted        = true
  kms_key_id               = aws_kms_key.db_encryption_key.arn
  delete_automated_backups = true
  db_name                  = "cloudnativedevopsplatformdb"
  skip_final_snapshot      = true  # Set to false in production for data safety
 
  tags = {
    Name = "MyDBInstance"
  }
}



resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow inbound traffic to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Or allow EC2 instances' security group access:
    # security_groups = [aws_security_group.ec2_sg.id]
  }
}
