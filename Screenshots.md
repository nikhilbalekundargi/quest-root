# Project Screenshots

This document contains screenshots taken during the project setup and deployment process. 

Application Endpoint - https://k8s-questapp-questapp-45b35b4b04-1111191681.ap-south-1.elb.amazonaws.com/

## Screenshots

### 1. Terraform output of S3 bucket and Dynamo DB Table for Storing State File on S3 Bucket Securedly 
![Backend  Resoruces Terrafrom Output ](./screenshots/1-backend-output.png)

### 2. S3 Bucket on AWS
![S3 Bucket with tfstate file](./screenshots/2-S3-Bucket.png)

### 3. Dynamo DB tabel on AWS
![Dynamo DB Table](./screenshots/3-Dynamo-DB.png)

### 4. Terraform Output of IAM-Role terraform code.
![IAM Role Terraform Output](./screenshots/4-iam-role-output.png)

### 5. Terraform Ouput of EKS cluster and VPC
![Docker Build](./screenshots/5-eks-vpc-output.png)

### 6. EKS Cluster on AWS
![EKS Cluster](./screenshots/6-EKS-Cluster.png)

### 7. VPC on AWS
![VPC](./screenshots/7-VPC.png)

### 8. Kubernetes output - Cluster Info, Namespace, Deployment, Services, Ingreess, ALB Contoller
![k8s resources](./screenshots/8-k8s-resources.png)

### 9. Access Web Page using Port Forward to get the Secret Word
![Secret_Word](./screenshots/9-localhost-secret-word.png)

### 10. Upload Self Signed Certifcate Generated on local to ACM
![Self Signed Certificate to ACM](./screenshots/10-Self-Signed-Certificate-Upload-to-ACL.png)

### 11. Application with HTTPS
![Index Page](./screenshots/11-application-web.png)

### 12. Docker check
![Index Page](./screenshots/12-docker-check.png)

### 13. Loadbalance check
![LoadBalance Page](./screenshots/13-loadbalance-check.png)

### 14. TLS check
![TLS Page](./screenshots/tls-https-check.png)