variable "service_launch_type" {
    type = string
    description = "ECS service laucnh type."
    default = "FARGATE"
}

variable "scheduling_strategy" {
    type = string
    description = "ECS service scheduling strategy."
    default = "REPLICA"
}

variable "container_port" {
    type = string
    description = "Container port."
    default = "REPLICA"
}

variable "network_mode" {
    type = string
    description = "Network mode."
    default = "awsvpc"
}

variable "ecs_task_cpu" {
    type = number
    description = "Task CPU."
    default = 256
}

variable "ecs_task_memory" {
    type = number
    description = "Task memory."
    default = 512
}