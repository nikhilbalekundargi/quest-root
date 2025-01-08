# Project Repository

This repository contains the code and configurations to deploy our application on AWS using Docker, Kubernetes, and Terraform. Below is the structure and details of the folders within this repository.

## Repository Structure

### 1. `app`
This folder contains the application code along with a Dockerfile. It also includes a README file with detailed instructions on how to build and push the Docker image to Amazon ECR.

### 2. `ci`
This folder contains Kubernetes YAML files necessary to deploy the application on an EKS cluster. It also includes a README file that covers:
- Security features considered for the deployment of the application on Kubernetes.
- Notes and explanations for each of the YAML files.
- Future improvements that can be applied to these YAML configurations.

### 3. `infra`
This folder contains Terraform code to create the necessary infrastructure on AWS. It is divided into three subfolders, each with its own purpose and a README file for detailed instructions.

#### Subfolders:
- **aws**: Contains Terraform code to create EKS and VPC infrastructure on AWS.
- **backend**: Contains Terraform code to create an S3 bucket and DynamoDB table for storing and locking the Terraform state file.
- **iam-role**: Contains Terraform code to create an IAM role for the Terraform user to provision resources.

Each subfolder has its own README file, which includes:
- Notes on the Terraform code.
- A brief explanation of the infrastructure being created.
- Instructions on how to execute the Terraform code to deploy the infrastructure.

### Additional Files

- **Improvement.md**: This file contains details on how we can improve or enhance the setup to make it production-ready.
- **Screenshots.md**: This file contains screenshots confirming the Terraform code execution, AWS resources, and application pages.

