variable "aws_region" {
  default = "us-east-1"
}

variable "ecr_repository_name" {
  default = "my-learn-ecr-repo"
}

variable "ecs_cluster_name" {
  default = "my-learn-ecs-cluster"
}

variable "ecs_service_name" {
  default = "my-learn-ecs-service"
}
