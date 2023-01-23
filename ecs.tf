resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-ecs-cluster"

  tags = {
    Name  = "${var.project_name}-ecs"
    Owner = var.owner
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.project_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type                        = var.service_launch_type
  scheduling_strategy                = var.scheduling_strategy

  network_configuration {
   security_groups  = [aws_security_group.ecs_sg.id]
   subnets          = [aws_subnet.pub_subnet.id]	
   assign_public_ip = true
 }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "service"
  network_mode             = var.network_mode
  requires_compatibilities = [var.service_launch_type]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-container"
      image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.worker.name}:latest"
      cpu       = var.ecs_task_memory
      essential = true
      networkMode = var.network_mode
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group": "${var.project_name}-log-group",
          "awslogs-region": var.aws_region,
          "awslogs-stream-prefix": "${var.project_name}-log-stream"
        }
      }
      environment = [
        {"name": "DATABASE_NAME", "value": var.database_name},
        {"name": "DATABASE_HOST", "value": aws_rds_cluster.test_rds_cluster.endpoint},
        {"name": "DATABASE_PORT", "value": var.database_port},
        {"name": "DATABASE_USER", "value": var.database_user},
        {"name": "DATABASE_PASS", "value": var.database_password},
        {"name": "SECRET_KEY", "value": var.database_secret_key},
        {"name": "DJANGO_SETTINGS_MODULE", "value": var.django_settings_module},
        {"name": "DATABASE_ENGINE", "value": var.database_engine}
    
      ]
    }
  ])
}