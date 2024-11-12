provider "aws" {
  region = var.aws_region
}

# Fetch subnet IDs from SSM
data "aws_ssm_parameter" "subnet_id_1" {
  name = "/my-vpc/public-subnet-id-1"
}

data "aws_ssm_parameter" "subnet_id_2" {
  name = "/my-vpc/public-subnet-id-2"
}

# Fetch security group ID from SSM
data "aws_ssm_parameter" "security_group_id" {
  name = "/my-vpc/security-group-id"
}

# Fetch ECS Task Execution Role ARN from SSM
data "aws_ssm_parameter" "ecs_task_execution_role_arn" {
  name = "/my-vpc/ecs_task_execution_role_arn"
}

# Fetch Lambda Invoke ECS Role ARN from SSM (if needed for any Lambda permissions)
data "aws_ssm_parameter" "lambda_invoke_ecs_role_arn" {
  name = "/my-vpc/lambda_invoke_ecs_role_arn"
}

# tfsec:ignore:aws-ecr-repository-customer-key
resource "aws_ecr_repository" "my_repo" {
  name = var.ecr_repository_name

  # Enable image scanning on push
  image_scanning_configuration {
    scan_on_push = true
  }

  # Enforce immutable tags
  image_tag_mutability = "IMMUTABLE"
}

# tfsec:ignore:aws-ecs-enable-container-insight
resource "aws_ecs_cluster" "my_cluster" {
  name = var.ecs_cluster_name

  # Enable Container Insights (optional, commented out for now)
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_ssm_parameter.ecs_task_execution_role_arn.value  # Fetch from SSM

  container_definitions = jsonencode([{
    name      = "my-app"
    image     = "${aws_ecr_repository.my_repo.repository_url}:latest"
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ]
  }])
}

resource "aws_ecs_service" "my_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [data.aws_ssm_parameter.subnet_id_1.value, data.aws_ssm_parameter.subnet_id_2.value]
    security_groups = [data.aws_ssm_parameter.security_group_id.value]
    assign_public_ip = true
  }
}
