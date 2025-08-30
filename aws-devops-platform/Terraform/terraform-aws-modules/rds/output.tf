output "db_instance_address" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.my_rds_instance.address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.my_rds_instance.port
}

output "db_instance_name" {
  description = "RDS database name"
  value       = aws_db_instance.my_rds_instance.db_name
}