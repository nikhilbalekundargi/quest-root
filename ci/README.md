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
```bash
# Create namespace
kubectl apply -f namespace.yaml

# Create service accounts
kubectl apply -f alb-sa.yaml
kubectl apply -f sa.yaml

# Apply secrets
kubectl apply -f secret.yaml

# Deploy application
kubectl apply -f deploy.yaml
kubectl apply -f service.yaml

# Configure ingress
kubectl apply -f ingress.yaml
```