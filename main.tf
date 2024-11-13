provider "aws" {
  region = var.aws_region
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
