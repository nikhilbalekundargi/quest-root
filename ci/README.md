## Security Features

### Pod Security
- Non-root user execution (UID: 1000)
- Privilege escalation disabled
- Read-only root filesystem
- Dropped capabilities
- Resource limits enforced

### Network Security
- ClusterIP service type
- TLS termination at ALB
- Namespace isolation
- AWS IAM integration

## Deployment Files

### alb-sa.yaml
- Creates ServiceAccount for AWS Load Balancer Controller
- IAM role integration for AWS permissions

### deploy.yaml
- 2 replicas for high availability
- Security context configuration
- Resource quotas
- Secret integration

### ingress.yaml
- ALB configuration
- TLS/HTTPS enabled
- Public facing
- SSL policy enforcement

### service.yaml
- Internal ClusterIP type
- Port 3000 target
- Label selector based routing

## Future Improvements

### Health Checks on deployment
- Add readiness probe
- Add liveness probe
- Add startup probe

### Pod Scheduling on deployment
- Node affinity rules
- Pod anti-affinity 
- Node tolerations

### Security Enhancements for ingress
- HTTP to HTTPS redirect
- Remove HTTP port 80

### Deployment Steps


## Deployment Steps

### Obtain Secret Word
```bash
# Create namespace
kubectl apply -f namespace.yaml

# Deploy application and service
kubectl apply -f deploy.yaml
kubectl apply -f service.yaml

# Create service accounts
kubectl apply -f sa.yaml

# Port forward the service to access it locally to get the secret_word
kubectl port-forward svc/my-service 8080:80

# Access the service on localhost to get the secret word
curl http://localhost:8080/secret

#Add above secret to deployment yaml
# Create secret on cluster
kubectl apply -f secret.yaml

# Update the deployment yaml 
kubectl apply -f deploy.yaml

# Create service account for ALB
kubectl apply -f alb-sa.yaml

# Create ingress
kubectl apply -f ingress.yaml
```

