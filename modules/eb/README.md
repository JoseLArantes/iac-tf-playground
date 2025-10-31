# Elastic Beanstalk Module

This module creates an AWS Elastic Beanstalk application and environment with proper IAM roles, VPC integration, and production-ready configurations.

## Features

- ✅ Elastic Beanstalk application and environment
- ✅ IAM roles for EC2 instances and service
- ✅ VPC integration with public/private subnet placement
- ✅ Auto Scaling configuration
- ✅ Application Load Balancer integration
- ✅ Enhanced health reporting
- ✅ Managed platform updates
- ✅ CloudWatch Logs integration
- ✅ Rolling updates support
- ✅ Environment variables configuration

## Usage

```hcl
module "elastic_beanstalk" {
  source = "./modules/eb"

  application_name        = "my-app"
  application_description = "My application description"
  environment             = "production"

  # VPC Configuration
  vpc_id                            = module.vpc.vpc_id
  public_subnet_ids                 = module.vpc.public_subnet_ids
  private_subnet_ids                = module.vpc.private_subnet_ids
  instance_security_group_id        = module.vpc.app_tier_security_group_id
  load_balancer_security_group_id   = module.vpc.web_tier_security_group_id

  # Instance Configuration
  instance_type        = "t3.small"
  autoscaling_min_size = 2
  autoscaling_max_size = 10

  # Platform
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.0 running Python 3.11"

  # Environment Variables
  environment_variables = {
    DATABASE_URL = "postgresql://..."
    API_KEY      = "your-api-key"
  }

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

## Supported Platform Stacks

Common solution stack names (check AWS for latest versions):

- **Python**: `64bit Amazon Linux 2023 v4.3.0 running Python 3.11`
- **Node.js**: `64bit Amazon Linux 2023 v6.1.0 running Node.js 20`
- **Docker**: `64bit Amazon Linux 2023 v4.2.0 running Docker`
- **Go**: `64bit Amazon Linux 2023 v4.1.0 running Go 1.21`
- **Java**: `64bit Amazon Linux 2023 v4.2.0 running Corretto 17`
- **.NET**: `64bit Amazon Linux 2023 v3.1.0 running .NET 8`
- **PHP**: `64bit Amazon Linux 2023 v4.1.0 running PHP 8.3`
- **Ruby**: `64bit Amazon Linux 2023 v4.2.0 running Ruby 3.2`

To get the latest stacks:
```bash
aws elasticbeanstalk list-available-solution-stacks
```

## Architecture

```
                                    Internet
                                       |
                                       v
                           +-----------------------+
                           | Application Load      |
                           | Balancer (Public)     |
                           +-----------------------+
                                       |
                    +------------------+------------------+
                    |                                     |
                    v                                     v
          +-----------------+                   +-----------------+
          | EC2 Instance    |                   | EC2 Instance    |
          | (Private Subnet)|                   | (Private Subnet)|
          +-----------------+                   +-----------------+
                    |                                     |
                    +------------------+------------------+
                                       |
                                       v
                               Auto Scaling Group
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| application_name | Name of the application | string | n/a | yes |
| environment | Environment name | string | n/a | yes |
| vpc_id | VPC ID | string | n/a | yes |
| public_subnet_ids | Public subnet IDs for load balancer | list(string) | n/a | yes |
| private_subnet_ids | Private subnet IDs for instances | list(string) | n/a | yes |
| instance_security_group_id | Security group for instances | string | n/a | yes |
| load_balancer_security_group_id | Security group for load balancer | string | n/a | yes |
| instance_type | EC2 instance type | string | `t3.micro` | no |
| autoscaling_min_size | Minimum instances | number | `1` | no |
| autoscaling_max_size | Maximum instances | number | `4` | no |
| solution_stack_name | Platform stack | string | Python 3.11 | no |
| environment_variables | Environment variables | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| application_name | Elastic Beanstalk application name |
| environment_name | Elastic Beanstalk environment name |
| environment_cname | CNAME of the environment |
| environment_endpoint_url | Fully qualified DNS name |
| load_balancers | List of load balancers |
| ec2_role_arn | ARN of the EC2 IAM role |
| service_role_arn | ARN of the service role |

## Deployment

### 1. Enable the Module

In your `main.tf`, uncomment the Elastic Beanstalk module.

### 2. Initialize and Apply

```bash
terraform init -backend-config="environments/principal.tfbackend"
terraform plan -var-file="environments/principal.tfvars"
terraform apply -var-file="environments/principal.tfvars"
```

### 3. Deploy Your Application

After the environment is created:

```bash
# Package your application
zip -r app.zip .

# Create application version
aws elasticbeanstalk create-application-version \
  --application-name <app-name>-<env> \
  --version-label v1 \
  --source-bundle S3Bucket=<bucket>,S3Key=app.zip

# Deploy version
aws elasticbeanstalk update-environment \
  --environment-name <app-name>-<env>-env \
  --version-label v1
```

Or use the EB CLI:

```bash
eb init
eb deploy
```

## Best Practices

1. **Use LoadBalanced environments** for production (already configured)
2. **Enable rolling updates** to minimize downtime (already configured)
3. **Use managed updates** for security patches (already configured)
4. **Enable CloudWatch logs** for monitoring (already configured)
5. **Set appropriate instance types** based on workload
6. **Configure health checks** for your application
7. **Use environment variables** for configuration (not secrets)
8. **Store secrets** in AWS Secrets Manager, not environment variables

## Security

- IAM roles follow least-privilege principle with AWS managed policies
- Instances are placed in private subnets
- Load balancer is in public subnets
- Security groups control traffic flow
- Enhanced health reporting enabled
- CloudWatch logs enabled for auditing

## Monitoring

The module enables:
- Enhanced health reporting
- CloudWatch Logs streaming
- Load balancer metrics
- Auto Scaling metrics

Access logs in CloudWatch:
```
/aws/elasticbeanstalk/<application-name>-<environment>-env/
```

## Troubleshooting

### Environment creation fails

Check the events:
```bash
aws elasticbeanstalk describe-events \
  --environment-name <app-name>-<env>-env
```

### Application health issues

Check health status:
```bash
aws elasticbeanstalk describe-environment-health \
  --environment-name <app-name>-<env>-env \
  --attribute-names All
```

### Instance logs

Access via EB Console or request bundle:
```bash
eb logs
```

## Cost Optimization

- Use `t3.micro` or `t3.small` for dev/staging
- Set appropriate min/max instance counts
- Enable application version lifecycle to delete old versions
- Use spot instances for non-production (requires custom configuration)
- Delete environments when not in use

