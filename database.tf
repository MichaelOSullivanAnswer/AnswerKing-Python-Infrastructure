resource "aws_db_subnet_group" "mysql-subnet-group" {
  name       = "aurora-mysql-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name  = "${var.project_name}-db-private-subnet-group"
    Owner = var.owner
  }
}

resource "aws_rds_cluster" "test_rds_cluster" {
  cluster_identifier     = "aurora-mysql"
  engine                 = "aurora-mysql"
  engine_mode            = "provisioned"
  engine_version         = "8.0.mysql_aurora.3.02.0"
  database_name          = var.database_name
  master_username        = var.database_user
  master_password        = var.database_password
  skip_final_snapshot    = true
  storage_encrypted      = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql-subnet-group.name

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }

  tags = {
    Name  = "${var.project_name}-rds-cluster"
    Owner = var.owner
  }
}

resource "aws_rds_cluster_instance" "aurora_mysql" {
  cluster_identifier   = aws_rds_cluster.test_rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.test_rds_cluster.engine
  engine_version       = aws_rds_cluster.test_rds_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.mysql-subnet-group.name

  auto_minor_version_upgrade = true
  availability_zone          = "eu-west-2a"

  tags = {
    Name  = "${var.project_name}-rds-cluster-instance"
    Owner = var.owner
  }
}



