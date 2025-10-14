# Deploying Docker Containers to Elastic Beanstalk

This guide explains how to deploy your Docker container from ECR to Elastic Beanstalk.

## Configuration

Your Elastic Beanstalk is configured to pull the Docker image from:
```
690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest
```

### Current Settings (in `environments/principal.tfvars`):

```hcl
eb_enabled              = false  # Set to true to deploy
eb_use_docker           = true
eb_solution_stack_name  = "64bit Amazon Linux 2023 v4.2.0 running Docker"
eb_docker_image         = "690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest"
eb_docker_container_port = 8000
```

## Prerequisites

1. **ECR Image Ready**: Ensure your Docker image is pushed to ECR:
   ```bash
   # Authenticate Docker to ECR
   aws ecr get-login-password --region us-east-1 | \
     docker login --username AWS --password-stdin 690488446884.dkr.ecr.us-east-1.amazonaws.com
   
   # Tag and push your image
   docker tag tmqa-backend:latest 690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest
   docker push 690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest
   ```

2. **IAM Permissions**: The EB EC2 instances automatically get `AmazonEC2ContainerRegistryReadOnly` policy to pull from ECR.

## How It Works

1. **Elastic Beanstalk** creates EC2 instances in private subnets
2. **Application Load Balancer** routes traffic from the internet to instances
3. **EC2 instances pull** the Docker image from ECR on startup
4. **Container runs** and exposes port 8000
5. **EB maps** container port 8000 to ALB port 80

## Deployment Steps

### 1. Enable Elastic Beanstalk

Edit `environments/principal.tfvars`:
```hcl
eb_enabled = true
```

### 2. Apply Infrastructure

```bash
terraform plan -var-file="environments/principal.tfvars"
terraform apply -var-file="environments/principal.tfvars"
```

This creates:
- Elastic Beanstalk application
- Elastic Beanstalk environment
- Application Load Balancer
- Auto Scaling Group
- IAM roles with ECR access

### 3. Create Application Version

Create a `Dockerrun.aws.json` file in your project root:

```json
{
  "AWSEBDockerrunVersion": "1",
  "Image": {
    "Name": "690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": 8000,
      "HostPort": 80
    }
  ],
  "Logging": "/var/log/nginx"
}
```

### 4. Deploy Application

**Option A: Using AWS Console**
1. Go to Elastic Beanstalk in AWS Console
2. Select your environment
3. Click "Upload and Deploy"
4. Upload a ZIP file containing `Dockerrun.aws.json`

**Option B: Using EB CLI**
```bash
# Install EB CLI
pip install awsebcli

# Initialize (one time)
eb init --platform docker --region us-east-1

# Deploy
zip app.zip Dockerrun.aws.json
eb deploy
```

**Option C: Using AWS CLI**
```bash
# Create application version
zip app.zip Dockerrun.aws.json
aws s3 cp app.zip s3://elasticbeanstalk-us-east-1-690488446884/tmqa-backend/app.zip

aws elasticbeanstalk create-application-version \
  --application-name "JLA Cloud-principal" \
  --version-label v1.0.0 \
  --source-bundle S3Bucket="elasticbeanstalk-us-east-1-690488446884",S3Key="tmqa-backend/app.zip"

# Deploy version
aws elasticbeanstalk update-environment \
  --environment-name "JLA Cloud-principal-env" \
  --version-label v1.0.0
```

## Updating the Docker Image

When you push a new image to ECR with the `:latest` tag:

1. **New deployments** automatically pull the latest image
2. **Existing instances** need to be replaced:
   ```bash
   # Trigger a deployment to pull new image
   eb deploy
   # Or restart the environment
   aws elasticbeanstalk restart-app-server --environment-name "JLA Cloud-principal-env"
   ```

## Using Specific Image Tags

Instead of `:latest`, use specific tags in production:

```hcl
# In environments/principal.tfvars
eb_docker_image = "690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:v1.2.3"
```

Then apply Terraform changes:
```bash
terraform apply -var-file="environments/principal.tfvars"
```

## Environment Variables

Add environment variables in `environments/principal.tfvars`:

```hcl
eb_environment_variables = {
  DATABASE_URL = "postgresql://user:pass@host:5432/db"
  REDIS_URL    = "redis://cache:6379/0"
  DEBUG        = "false"
  LOG_LEVEL    = "info"
}
```

These are injected into the container as environment variables.

## Container Requirements

Your Docker container must:

1. **Expose port 8000** (or update `eb_docker_container_port`)
2. **Handle HTTP traffic** on that port
3. **Start automatically** when container runs
4. **Log to stdout/stderr** for CloudWatch Logs

Example Dockerfile:
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY . .
RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Health Checks

Elastic Beanstalk performs health checks on `/` by default. To customize:

Add to your EB environment settings in the module (or via console):
- Health check path: `/health` or `/api/health`
- Timeout: 5 seconds
- Interval: 30 seconds

## Accessing Your Application

After deployment:

1. **Get the URL**:
   ```bash
   terraform output eb_environment_url
   # Or
   aws elasticbeanstalk describe-environments \
     --environment-names "JLA Cloud-principal-env" \
     --query "Environments[0].CNAME" --output text
   ```

2. **Access via browser**:
   ```
   http://<environment-cname>.us-east-1.elasticbeanstalk.com
   ```

3. **Add custom domain** (optional):
   - Create Route53 record pointing to the CNAME
   - Add SSL certificate via AWS Certificate Manager
   - Configure HTTPS listener in EB

## Monitoring

### CloudWatch Logs

Logs are automatically streamed to CloudWatch:
```
/aws/elasticbeanstalk/JLA Cloud-principal-env/
```

View logs:
```bash
aws logs tail /aws/elasticbeanstalk/JLA\ Cloud-principal-env/ --follow
```

### Metrics

Available in CloudWatch:
- Request count
- Latency
- HTTP status codes
- Instance health
- CPU/Memory usage

## Troubleshooting

### Container fails to start

1. **Check CloudWatch Logs** for container errors
2. **Test locally**:
   ```bash
   docker run -p 8000:8000 690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest
   ```
3. **Verify ECR image exists**:
   ```bash
   aws ecr describe-images --repository-name tmqa-backend
   ```

### Health check failures

1. **Test the endpoint**:
   ```bash
   curl http://<instance-ip>:8000/
   ```
2. **Check container logs** in CloudWatch
3. **Verify port 8000** is exposed and listening

### Can't pull from ECR

1. **Verify IAM role** has ECR permissions (already configured)
2. **Check ECR repository permissions**:
   ```bash
   aws ecr get-repository-policy --repository-name tmqa-backend
   ```

### Environment won't deploy

1. **Check security groups** allow traffic
2. **Verify subnets** have proper routing
3. **Review EB events**:
   ```bash
   aws elasticbeanstalk describe-events --environment-name "JLA Cloud-principal-env"
   ```

## Cost Optimization

- Use `t3.micro` for dev/testing
- Scale down min instances to 1 for non-prod
- Delete environment when not in use:
  ```hcl
  eb_enabled = false
  ```
  Then apply Terraform

## CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Deploy to EB

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v5
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1
      
      - name: Build and push image
        run: |
          aws ecr get-login-password | docker login --username AWS --password-stdin 690488446884.dkr.ecr.us-east-1.amazonaws.com
          docker build -t tmqa-backend .
          docker tag tmqa-backend:latest 690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest
          docker push 690488446884.dkr.ecr.us-east-1.amazonaws.com/tmqa-backend:latest
      
      - name: Deploy to Elastic Beanstalk
        run: |
          aws elasticbeanstalk restart-app-server --environment-name "JLA Cloud-principal-env"
```

