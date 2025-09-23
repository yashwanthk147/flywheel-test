# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg-${var.env}"
  description = "Allow Postgres traffic from App SG"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description     = "Postgres from App SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.app.outputs.app_sg_id] 
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-rds-sg-${var.env}"
  }
}

# Subnet Group for RDS (use private subnets)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project}-rds-subnet-${var.env}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = {
    Name = "${var.project}-rds-subnet-${var.env}"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier              = "${var.project}-postgres-${var.env}"
  engine                  = "postgres"
  engine_version          = "17.4"                  
  instance_class          = "db.t3.micro"            
  allocated_storage       = 10

  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = 5432

  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  multi_az                = true                     
  backup_retention_period = 7
  skip_final_snapshot     = true                    
  publicly_accessible     = false                

  tags = {
    Name = "${var.project}-postgres-${var.env}"
  }
}
