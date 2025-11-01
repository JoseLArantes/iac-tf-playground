# Atlantis Integration Setup

This project is integrated with Atlantis for automated Terraform plan and apply operations.

## Configuration Overview

### Atlantis Configuration (`.atlantis.yaml`)

The project is configured with two environments:

1. **Dev Environment** - Development environment for testing changes
2. **Principal Environment** - Main production environment

Each environment has:
- Its own backend configuration (S3 state bucket)
- Separate variable files
- Independent Terraform workspaces
- Approval requirements for applies

### Environment Files

- `environments/dev.tfvars` - Dev environment variables
- `environments/dev.tfbackend` - Dev backend configuration
- `environments/principal.tfvars` - Principal environment variables
- `environments/principal.tfbackend` - Principal backend configuration

### GitHub Integration

The integration works through:
1. **Webhook Configuration** - Atlantis receives webhooks from GitHub via ngrok tunnel
2. **GitHub Actions** - The `.github/workflows/atlantis.yaml` workflow notifies Atlantis on PR events
3. **Atlantis Server** - Running at: https://enneasyllabic-reid-unanimatingly.ngrok-free.dev

## How It Works

### For Developers

1. **Create a Pull Request** - When you open a PR, Atlantis automatically:
   - Detects which environments are affected by file changes
   - Runs `terraform plan` for each affected environment
   - Comments the plan results on the PR

2. **Review Plans** - Review the plans in the PR comments

3. **Apply Changes** - To apply changes:
   - Comment on the PR: `atlantis apply -p <project-name>`
   - Approved reviewers can apply
   - Example: `atlantis apply -p dev` or `atlantis apply -p principal`

### Autoplan Triggers

Atlantis will automatically run plans when these files are modified:
- Any `*.tf` files (Terraform modules)
- Environment-specific files (`environments/dev.*` or `environments/principal.*`)

### Commands

- `atlantis plan -p dev` - Run plan for dev environment
- `atlantis plan -p principal` - Run plan for principal environment
- `atlantis apply -p dev` - Apply changes to dev environment
- `atlantis apply -p principal` - Apply changes to principal environment
- `atlantis approve_policies -p <project>` - Approve OPA policies (if used)

## Atlantis Server Setup

To configure your Atlantis server:

### 1. GitHub Webhook Configuration

In your GitHub repository settings:
1. Go to Settings → Webhooks
2. Add webhook pointing to: `https://enneasyllabic-reid-unanimatingly.ngrok-free.dev/events`
3. Content type: `application/json`
4. Events: `Pull Request`, `Issue Comment`, `Push`

### 2. Atlantis Server Requirements

Your Atlantis server needs:
- AWS credentials to access S3 backends and AWS resources
- Permissions to write comments to GitHub PRs
- Network access to GitHub

### 3. Environment Variables

Configure in your Atlantis server:
```bash
ATLANTIS_GH_TOKEN=<your-github-token>
ATLANTIS_GH_APP_ID=<github-app-id>  # If using GitHub App
ATLANTIS_GH_APP_KEY=<github-app-key>  # If using GitHub App
ATLANTIS_GH_WEBHOOK_SECRET=<webhook-secret>
ATLANTIS_DEFAULT_TF_VERSION=1.8.5
ATLANTIS_LOG_LEVEL=info
ATLANTIS_REPO_WHITELIST=github.com/JoseLArantes/*
```

### 4. AWS Credentials

Atlantis needs AWS credentials to:
- Access S3 buckets for state storage
- Create/manage AWS resources through Terraform

Configure via:
- IAM role (recommended for ECS/EC2 deployments)
- Environment variables
- AWS credentials file

## Troubleshooting

### Plans not running automatically
- Check if files are modified in the `when_modified` paths
- Verify webhook is configured correctly
- Check Atlantis server logs

### Apply failures
- Ensure S3 state buckets exist
- Verify AWS credentials have sufficient permissions
- Check Terraform version matches (v1.8.5)

### Workspace issues
- Each environment uses separate S3 backends
- Workspaces are automatically created if they don't exist

## Security Notes

- All applies require approval (`apply_requirements: [approved]`)
- Atlantis will not merge PRs automatically (`automerge: false`)
- Source branches are not deleted on merge (`delete_source_branch_on_merge: false`)
- Use separate state buckets per environment for isolation

## Next Steps

To complete the integration:

1. **Configure GitHub Webhook** (Primary Method):
   - Go to your GitHub repository: `https://github.com/JoseLArantes/iac-tf-playground`
   - Settings → Webhooks → Add webhook
   - Payload URL: `https://enneasyllabic-reid-unanimatingly.ngrok-free.dev/events`
   - Content type: `application/json`
   - Select events: `Pull requests`, `Issue comments`, `Pushes`
   - Add webhook

2. **OR use GitHub Actions** (Alternative Method):
   - The `.github/workflows/atlantis.yaml` workflow is already configured
   - This will work automatically once webhook is set up OR if using Atlantis GitHub App
   - The workflow uses `runatlantis/atlantis-github-app@v0.8.0` action

3. **Test the Integration**:
   - Create a test PR modifying a `.tf` file
   - Atlantis should automatically comment with plan results
   - Try running: `atlantis plan -p dev` or `atlantis plan -p principal`

4. **Verify Atlantis Server Configuration**:
   - Ensure your Atlantis server is configured with the correct environment variables
   - Verify AWS credentials are accessible to Atlantis
   - Check that ngrok tunnel is active and pointing to your Atlantis server

## Resources

- [Atlantis Documentation](https://www.runatlantis.io/docs/)
- [Atlantis GitHub App](https://www.runatlantis.io/docs/github-app/)
- [Terraform Workspaces](https://www.terraform.io/docs/state/workspaces.html)

