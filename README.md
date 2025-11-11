# E-Commerce Website - Multi-Platform Deployment & Monitoring

A fully responsive e-commerce website built with HTML, CSS, and JavaScript, demonstrating modern DevOps practices with multiple deployment options and monitoring capabilities.

## 🎯 Project Overview

This project showcases three different deployment methods:

- **Docker** - Containerized local deployment
- **Ansible** - Automated AWS S3 deployment
- **Terraform** - Infrastructure as Code AWS deployment

All deployments can be monitored using **Nagios** for uptime tracking and performance monitoring.

## 🚀 Features

- ✅ Fully responsive e-commerce website
- ✅ No frameworks (vanilla JavaScript)
- ✅ Docker containerization
- ✅ Ansible automation
- ✅ Terraform IaC
- ✅ Nagios monitoring integration
- ✅ Nginx web server with optimizations
- ✅ Security headers and caching

## 📋 Prerequisites

### For Docker Deployment

- Docker Desktop installed
- Docker Compose

### For AWS Deployments (Ansible/Terraform)

- AWS CLI configured with credentials
- AWS account with S3 permissions
- Ansible (for Ansible deployment)
- Terraform (for Terraform deployment)

### For Monitoring

- Nagios installed (Linux/WSL)
- Access to Nagios web interface

## 🐳 Docker Deployment

### Quick Start

```bash
# Build and start container
docker-compose up -d --build

# Access website
http://localhost:8080

# View logs
docker logs e-commerce-dev

# Stop container
docker-compose down
```

### Features

- Nginx web server with custom configuration
- Gzip compression enabled
- Static asset caching
- Security headers
- Health checks

## 🤖 Ansible Deployment (AWS S3)

### Prerequisites

⚠️ **Important:** Before running, update the project path in `ansible/playbooks/ansible-only-deploy.yml`:

```yaml
# Line 17: Update this variable with your actual project path
project_dir: "C:\\Users\\YourUsername\\Desktop\\e-commerce-project"
```

### Deploy to AWS

```bash
# Navigate to project root
cd /path/to/e-commerce-project

# Run deployment playbook
ansible-playbook ansible/playbooks/ansible-only-deploy.yml

# Note the output URL
# Example: http://ansible-demo-1234567890.s3-website-us-east-1.amazonaws.com
```

### Apply Bucket Policy (Manual Step)

After deployment, run the command shown in the output:

```bash
aws s3api put-bucket-policy --bucket ansible-demo-XXXXXXXXXX --policy '{"Version":"2012-10-17","Statement":[{"Sid":"PublicReadGetObject","Effect":"Allow","Principal":"*","Action":"s3:GetObject","Resource":"arn:aws:s3:::ansible-demo-XXXXXXXXXX/*"}]}'
```

### Cleanup

```bash
ansible-playbook ansible/playbooks/ansible-cleanup.yml
```

## 🏗️ Terraform Deployment (AWS S3)

### Initialize and Deploy

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply

# Get website URL
terraform output website_url
```

### Upload Website Files

```bash
# From project root
aws s3 sync . s3://your-bucket-name \
  --exclude "terraform/*" \
  --exclude ".git/*" \
  --exclude "ansible/*" \
  --exclude "*.md"
```

### Cleanup

```bash
terraform destroy
```

## 📊 Nagios Monitoring Setup

### Configuration File Location

```
/etc/nagios4/conf.d/ecommerce-monitoring.cfg
```

### Add Monitoring

1. Copy the template from `nagios-monitoring-template.cfg`
2. Update the URLs with your deployment URLs
3. Test configuration:

```bash
sudo nagios4 -v /etc/nagios4/nagios.cfg
```

4. Restart Nagios:

```bash
sudo systemctl restart nagios4
```

### Access Dashboard

```
http://localhost/nagios4
```

### What Gets Monitored

- ✅ Host availability (ping)
- ✅ HTTP service status
- ✅ Website content verification
- ✅ Response time monitoring

## 📁 Project Structure

```
e-commerce-project/
├── index.html                      # Main website
├── css/                            # Stylesheets
├── js/                             # JavaScript files
├── images/                         # Image assets
├── nginx.conf                      # Nginx configuration
├── Dockerfile                      # Docker image definition
├── docker-compose.yml              # Docker orchestration
├── ansible/
│   └── playbooks/
│       ├── ansible-only-deploy.yml # AWS deployment
│       └── ansible-cleanup.yml     # Resource cleanup
├── terraform/
│   ├── main.tf                     # Infrastructure definition
│   ├── variables.tf                # Input variables
│   └── outputs.tf                  # Output values
└── nagios-monitoring-template.cfg  # Nagios config template
```

## 🔧 Configuration

### Docker

Edit `docker-compose.yml` to change:

- Port mapping (default: 8080:80)
- Container name
- Health check settings

### Ansible

Edit `ansible/playbooks/ansible-only-deploy.yml` to change:

- AWS region (default: us-east-1)
- Bucket naming pattern

### Terraform

Create `terraform/terraform.tfvars`:

```hcl
aws_region  = "us-east-1"
bucket_name = "your-unique-bucket-name"
environment = "production"
```

### Nginx

Edit `nginx.conf` to customize:

- Compression settings
- Cache durations
- Security headers

## 📚 Documentation

- `PROJECT_EXPLANATION.md` - Comprehensive guide to all components
- `ANSIBLE_GUIDE.md` - Ansible deployment details
- `DEMO_GUIDE.md` - Demo walkthrough
- `COMMAND_REFERENCE.md` - Quick command reference
- `nagios-setup.md` - Nagios configuration guide

## 🎯 Use Cases

### Local Development

Use Docker for fast local testing and development.

### Quick Demos

Use Ansible for rapid AWS deployment (2-3 minutes).

### Production Deployment

Use Terraform for managed, version-controlled infrastructure.

### Monitoring

Use Nagios to track uptime and performance across all deployments.

## 🔒 Security Notes

- Never commit AWS credentials to Git
- Use IAM roles with minimal required permissions
- Enable S3 bucket versioning for production
- Configure CloudFront for HTTPS in production
- Review security headers in nginx.conf

## 🐛 Troubleshooting

### Docker Issues

```bash
# View container logs
docker logs e-commerce-dev

# Restart container
docker-compose restart

# Rebuild from scratch
docker-compose down
docker-compose up -d --build
```

### AWS Deployment Issues

```bash
# Check AWS credentials
aws sts get-caller-identity

# List S3 buckets
aws s3 ls

# Check bucket policy
aws s3api get-bucket-policy --bucket your-bucket-name
```

### Nagios Issues

```bash
# Test configuration
sudo nagios4 -v /etc/nagios4/nagios.cfg

# Check service status
sudo systemctl status nagios4

# View logs
sudo tail -f /var/log/nagios4/nagios.log
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test all deployment methods
5. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Glide.js for carousel functionality
- Nginx for web server
- AWS for cloud infrastructure
- Docker for containerization
- Ansible and Terraform for automation

## 📞 Support

For issues and questions:

- Check the documentation in the `/docs` folder
- Review `PROJECT_EXPLANATION.md` for detailed explanations
- Open an issue on GitHub

---

**Note:** This project is for educational and demonstration purposes. For production use, implement additional security measures, monitoring, and backup strategies.
