# ECS Deployment with Terraform and GitHub Actions

This project demonstrates how to deploy a Dockerized application to AWS using ECR and ECS with Terraform, and automate the process using GitHub Actions.

## Project Setup

1. Set up your AWS credentials using environment variables or the AWS CLI.
2. Modify the Terraform variables in `variables.tf` to suit your needs.
3. Ensure you have a Dockerfile in the `myapp/` directory.

## Steps

1. **Build the Docker image**: The Dockerfile in `myapp/` builds the Docker image for your application.
2. **Push to ECR**: The image is pushed to the AWS ECR repository created by Terraform.
3. **Deploy to ECS**: ECS is used to run the Docker container in a managed Fargate cluster.

## Deploy Using GitHub Actions

This project includes a GitHub Actions workflow for automatic deployment. It will:

- Build the Docker image.
- Push the image to ECR.
- Deploy the ECS service using Terraform.
