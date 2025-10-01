resource "aws_db_instance" "tf_rds_instance1" {
  allocated_storage      = 10
  db_name                = "yash_demo"
  identifier             = "nodejs-mysql-rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "yash12345"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.tf_rds_sg1.id]
}

resource "aws_security_group" "tf_rds_sg1" {
  vpc_id      = "vpc-0d2c649773a148713"
  name        = "rds_sg"
  description = "allow Mysql traffic"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["122.161.49.44/32"]
    security_groups = [aws_security_group.tf_ec2_vpc1.id] # allow traffice from ec2 security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}  

locals {
  rds_endpoint = element(split(":", aws_db_instance.tf_rds_instance1.endpoint), 0)
}

output "rds_endpoint" {
  value = local.rds_endpoint
}
output "rds_username" {
  value = aws_db_instance.tf_rds_instance1.username
}
output "db_name" {
  value = aws_db_instance.tf_rds_instance1.db_name
}