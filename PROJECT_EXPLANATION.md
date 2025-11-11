# Complete Project Explanation: E-commerce Deployment & Monitoring

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Docker Deployment](#docker-deployment)
3. [Ansible Deployment](#ansible-deployment)
4. [Terraform Deployment](#terraform-deployment)
5. [Nagios Monitoring](#nagios-monitoring)
6. [File Structure & Purpose](#file-structure--purpose)
7. [Commands Reference](#commands-reference)

---

## 🎯 Project Overview

This project demonstrates **three different ways** to deploy an e-commerce website:

1. **Docker** - Local containerized deployment
2. **Ansible** - AWS S3 deployment using automation
3. **Terraform** - AWS S3 + CloudFront deployment using Infrastructure as Code

All deployments are monitored using **Nagios** for uptime and performance tracking.

---

## 🐳 Docker Deployment

### What is Docker?

Docker packages your application and all its dependencies into a container that runs consistently anywhere.

### Files Involved:

#### 1. **Dockerfile**

```dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
```

**What it does:**

- Uses nginx web server (Alpine Linux - lightweight)
- Copies all website files into the container
- Creates a portable, runnable package

#### 2. **docker-compose.yml**

```yaml
services:
  e-commerce-app:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
```

**What it does:**

- **build: .** - Builds Docker image from Dockerfile
- **ports: "8080:80"** - Maps container port 80 to host port 8080
- **volumes** - Mounts custom nginx.conf into container
- **healthcheck** - Monitors if container is healthy
- **networks** - Creates isolated network for container

#### 3. **nginx.conf**

**What it does:**

- **Gzip compression** - Reduces file sizes for faster loading
- **Static asset caching** - Browser caches CSS/JS/images for 1 year
- **Security headers** - Protects against XSS, clickjacking
- **SPA routing** - Handles single-page app navigation
- **Logging** - Tracks access and errors

### Docker Commands:

```bash
# Build and start container
docker-compose up -d --build

# View running containers
docker ps

# View container logs
docker logs e-commerce-dev

# Stop and remove container
docker-compose down

# Restart container
docker-compose restart
```

**Why use Docker?**

- ✅ Fast local development
- ✅ Consistent environment
- ✅ Easy to start/stop
- ✅ No cloud costs
- ✅ Perfect for testing

---

## 🤖 Ansible Deployment

### What is Ansible?

Ansible is an automation tool that executes tasks on servers using simple YAML playbooks.

### Files Involved:

#### 1. **ansible/playbooks/ansible-only-deploy.yml**

**Structure:**

```yaml
- name: Ansible-Only Fast Website Deployment
  hosts: localhost
  vars:
    bucket_name: "ansible-demo-{{ ansible_date_time.epoch }}"
    aws_region: "us-east-1"
  tasks:
    - name: Create S3 bucket
    - name: Configure website hosting
    - name: Upload files
    - name: Set public access
```

**What each task does:**

**Task 1: Create S3 bucket**

```yaml
command: aws s3 mb s3://{{ bucket_name }} --region {{ aws_region }}
```

- Creates new S3 bucket with timestamp name
- Example: `ansible-demo-1762802001`

**Task 2: Configure website hosting**

```yaml
command: aws s3 website s3://{{ bucket_name }} --index-document index.html
```

- Enables S3 static website hosting
- Sets index.html as homepage

**Task 3: Make bucket public**

```yaml
command: aws s3api put-public-access-block --bucket {{ bucket_name }}
  --public-access-block-configuration BlockPublicAcls=false,BlockPublicPolicy=false
```

- Removes public access restrictions
- Allows anyone to view website

**Task 4: Upload files**

```yaml
command: aws s3 sync . s3://{{ bucket_name }}
  --exclude terraform/* --exclude .git/* --exclude ansible/*
```

- Syncs all website files to S3
- Excludes infrastructure files

**Task 5: Set bucket policy**

```yaml
Policy: Allow Principal:* to s3:GetObject on bucket/*
```

- Makes all files publicly readable
- Required for website to work

#### 2. **ansible/playbooks/ansible-cleanup.yml**

**What it does:**

- Lists all buckets starting with "ansible-demo-"
- Empties each bucket (removes all files)
- Deletes bucket policies
- Removes website configurations
- Deletes the buckets
- Verifies cleanup completed

### Ansible Commands:

```bash
# Deploy website to AWS
ansible-playbook ansible/playbooks/ansible-only-deploy.yml

# Clean up AWS resources
ansible-playbook ansible/playbooks/ansible-cleanup.yml

# Check playbook syntax
ansible-playbook --syntax-check ansible/playbooks/ansible-only-deploy.yml

# Dry run (don't execute)
ansible-playbook --check ansible/playbooks/ansible-only-deploy.yml
```

**Why use Ansible?**

- ✅ Fast deployment (2-3 minutes)
- ✅ Simple YAML syntax
- ✅ No state management needed
- ✅ Great for quick demos
- ✅ Easy to understand

---

## 🏗️ Terraform Deployment

### What is Terraform?

Terraform is Infrastructure as Code (IaC) tool that manages cloud resources using declarative configuration.

### Files Involved:

#### 1. **terraform/main.tf**

**Provider Configuration:**

```hcl
provider "aws" {
  region = var.aws_region
}
```

- Connects to AWS
- Uses region from variables

**Resource 1: S3 Bucket**

```hcl
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "E-commerce Website"
  }
}
```

- Creates S3 bucket
- Adds tags for organization

**Resource 2: Website Configuration**

```hcl
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id
  index_document {
    suffix = "index.html"
  }
}
```

- Enables static website hosting
- Sets index.html as homepage

**Resource 3: Public Access Block**

```hcl
resource "aws_s3_bucket_public_access_block" "website_bucket_pab" {
  bucket = aws_s3_bucket.website_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

- Disables all public access restrictions
- Required for public website

**Resource 4: Bucket Policy**

```hcl
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
    }]
  })
}
```

- Allows public read access
- Makes files downloadable by anyone

#### 2. **terraform/variables.tf**

```hcl
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  default     = "production"
}
```

**What it does:**

- Defines input variables
- Sets default values
- Allows customization without changing main.tf

#### 3. **terraform/outputs.tf**

```hcl
output "website_url" {
  description = "S3 website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket
}
```

**What it does:**

- Displays important information after deployment
- Shows website URL
- Shows bucket name

### Terraform Commands:

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform (first time only)
terraform init

# Preview changes
terraform plan

# Apply changes (deploy)
terraform apply

# Destroy all resources
terraform destroy

# Show current state
terraform show

# List all resources
terraform state list

# Get specific output
terraform output website_url
```

**Terraform Workflow:**

1. **init** - Downloads AWS provider plugin
2. **plan** - Shows what will be created/changed
3. **apply** - Creates resources in AWS
4. **destroy** - Removes all resources

**Why use Terraform?**

- ✅ Infrastructure as Code
- ✅ State management
- ✅ Preview changes before applying
- ✅ Easy rollback
- ✅ Version control friendly
- ✅ Industry standard

---

## 📊 Nagios Monitoring

### What is Nagios?

Nagios is a monitoring system that checks if your websites are up and running, and alerts you if they go down.

### Configuration File: nagios-monitoring-template.cfg

**Structure:**

```cfg
define host {
    host_name       docker-ecommerce
    address         127.0.0.1
    check_command   check-host-alive
}

define service {
    host_name           docker-ecommerce
    service_description HTTP Port 8080
    check_command       check_http!-H 127.0.0.1 -p 8080
}
```

### Components Explained:

#### 1. **Host Definition**

```cfg
define host {
    host_name                   docker-ecommerce
    alias                       Docker E-commerce (Local)
    address                     127.0.0.1
    check_command               check-host-alive
    max_check_attempts          3
    check_period                24x7
    contact_groups              admins
    notification_options        d,u,r
}
```

**What each field means:**

- **host_name** - Unique identifier for this host
- **alias** - Human-readable name
- **address** - IP address or domain name to monitor
- **check_command** - How to check if host is alive (ping)
- **max_check_attempts** - Try 3 times before marking as down
- **check_period** - Monitor 24 hours a day, 7 days a week
- **contact_groups** - Who to notify (admins)
- **notification_options** - When to notify:
  - **d** = down
  - **u** = unreachable
  - **r** = recovery (back up)

#### 2. **Service Definition**

```cfg
define service {
    host_name                   docker-ecommerce
    service_description         HTTP Port 8080
    check_command               check_http!-H 127.0.0.1 -p 8080
    max_check_attempts          3
    check_period                24x7
    contact_groups              admins
}
```

**What each field means:**

- **host_name** - Which host this service belongs to
- **service_description** - What is being checked
- **check_command** - How to check the service:
  - **check_http** - Use HTTP check plugin
  - **-H 127.0.0.1** - Check this host
  - **-p 8080** - On this port
- **max_check_attempts** - Retry 3 times before alerting
- **check_period** - Check continuously
- **contact_groups** - Who to notify

#### 3. **Check Commands Explained**

**check-host-alive**

```bash
/usr/lib/nagios/plugins/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100%
```

- Pings the host
- Warning if response > 3 seconds or 80% packet loss
- Critical if response > 5 seconds or 100% packet loss

**check_http**

```bash
/usr/lib/nagios/plugins/check_http -H hostname -p port
```

- Makes HTTP request to website
- Returns OK if HTTP 200 response
- Returns CRITICAL if connection fails or HTTP error

**check_http with content**

```bash
/usr/lib/nagios/plugins/check_http -H hostname -s "E-commerce"
```

- Checks if page contains "E-commerce" text
- Verifies website content is correct

**check_http with response time**

```bash
/usr/lib/nagios/plugins/check_http -H hostname -w 3 -c 5
```

- Warning if response time > 3 seconds
- Critical if response time > 5 seconds

### Nagios Commands:

```bash
# Test configuration
sudo nagios4 -v /etc/nagios4/nagios.cfg

# Restart Nagios
sudo systemctl restart nagios4

# Check Nagios status
sudo systemctl status nagios4

# View Nagios logs
sudo tail -f /var/log/nagios4/nagios.log

# Force immediate check (in web UI)
# Click on service > "Re-schedule the next check of this service"
```

### Nagios Dashboard:

**Status Colors:**

- 🟢 **GREEN (OK)** - Service is working normally
- 🟡 **YELLOW (WARNING)** - Service is slow or degraded
- 🔴 **RED (CRITICAL)** - Service is down or failing
- ⚪ **GRAY (UNKNOWN)** - Cannot determine status

**What Nagios Monitors:**

1. **Host Status** - Is the server reachable?
2. **HTTP Service** - Is the website responding?
3. **Website Content** - Does the page contain expected content?
4. **Response Time** - How fast is the website?

---

## 📁 File Structure & Purpose

```
e-commerce-project/
├── index.html                          # Main website file
├── css/, js/, images/                  # Website assets
├── nginx.conf                          # Nginx web server configuration
├── Dockerfile                          # Docker container definition
├── docker-compose.yml                  # Docker orchestration
│
├── ansible/
│   ├── ansible.cfg                     # Ansible configuration
│   ├── inventory/hosts                 # Server inventory (empty for localhost)
│   └── playbooks/
│       ├── ansible-only-deploy.yml     # Deploy to AWS S3
│       └── ansible-cleanup.yml         # Clean up AWS resources
│
├── terraform/
│   ├── main.tf                         # Main infrastructure definition
│   ├── variables.tf                    # Input variables
│   └── outputs.tf                      # Output values
│
├── nagios-monitoring-template.cfg      # Nagios monitoring configuration
│
└── Documentation/
    ├── ANSIBLE_GUIDE.md                # Ansible usage guide
    ├── DEMO_GUIDE.md                   # Demo instructions
    ├── COMMAND_REFERENCE.md            # Command cheat sheet
    └── nagios-setup.md                 # Nagios setup guide
```

---

## 🎮 Commands Reference

### Docker Commands

```bash
# Start container
docker-compose up -d --build

# Stop container
docker-compose down

# View logs
docker logs e-commerce-dev

# Check status
docker ps

# Access website
http://localhost:8080
```

### Ansible Commands

```bash
# Deploy to AWS
ansible-playbook ansible/playbooks/ansible-only-deploy.yml

# Clean up AWS
ansible-playbook ansible/playbooks/ansible-cleanup.yml

# Check syntax
ansible-playbook --syntax-check playbook.yml

# Dry run
ansible-playbook --check playbook.yml
```

### Terraform Commands

```bash
# Initialize
cd terraform
terraform init

# Plan changes
terraform plan

# Deploy
terraform apply

# Destroy
terraform destroy

# Show outputs
terraform output

# Show state
terraform show
```

### Nagios Commands

```bash
# Test config
sudo nagios4 -v /etc/nagios4/nagios.cfg

# Restart service
sudo systemctl restart nagios4

# Check status
sudo systemctl status nagios4

# View logs
sudo tail -f /var/log/nagios4/nagios.log

# Access dashboard
http://localhost/nagios4
```

### AWS CLI Commands

```bash
# List S3 buckets
aws s3 ls

# View bucket contents
aws s3 ls s3://bucket-name

# Delete bucket
aws s3 rb s3://bucket-name --force

# Check bucket policy
aws s3api get-bucket-policy --bucket bucket-name
```

---

## 🔄 Deployment Comparison

| Feature            | Docker    | Ansible     | Terraform  |
| ------------------ | --------- | ----------- | ---------- |
| **Speed**          | Instant   | 2-3 min     | 30 sec     |
| **Cost**           | Free      | AWS costs   | AWS costs  |
| **Complexity**     | Simple    | Medium      | Medium     |
| **Use Case**       | Local dev | Quick demos | Production |
| **Rollback**       | Easy      | Manual      | Easy       |
| **State**          | None      | None        | Managed    |
| **Learning Curve** | Easy      | Medium      | Medium     |

---

## 🎯 When to Use Each Tool

### Use Docker When:

- ✅ Developing locally
- ✅ Testing changes quickly
- ✅ No internet needed
- ✅ Learning the application
- ✅ Demonstrating without AWS costs

### Use Ansible When:

- ✅ Quick AWS deployment needed
- ✅ Simple automation required
- ✅ No state management needed
- ✅ Running one-off tasks
- ✅ Comfortable with YAML

### Use Terraform When:

- ✅ Managing production infrastructure
- ✅ Need version control for infrastructure
- ✅ Want to preview changes
- ✅ Need state management
- ✅ Working in a team
- ✅ Industry standard required

### Use Nagios When:

- ✅ Need uptime monitoring
- ✅ Want performance metrics
- ✅ Need alerting for downtime
- ✅ Tracking SLA compliance
- ✅ Multiple deployments to monitor

---

## 🚀 Complete Workflow Example

### Scenario: Deploy and Monitor E-commerce Site

**Step 1: Local Development (Docker)**

```bash
# Start local development
docker-compose up -d --build

# Test locally
curl http://localhost:8080

# View in browser
open http://localhost:8080
```

**Step 2: Deploy to AWS (Ansible)**

```bash
# Deploy to AWS
ansible-playbook ansible/playbooks/ansible-only-deploy.yml

# Note the output URL
# Example: http://ansible-demo-1762802001.s3-website-us-east-1.amazonaws.com
```

**Step 3: Add Monitoring (Nagios)**

```bash
# Edit Nagios config
sudo nano /etc/nagios4/conf.d/ecommerce-monitoring.cfg

# Replace ANSIBLE_URL_HERE with your URL
# Test config
sudo nagios4 -v /etc/nagios4/nagios.cfg

# Restart Nagios
sudo systemctl restart nagios4

# Check dashboard
open http://localhost/nagios4
```

**Step 4: Clean Up (Ansible)**

```bash
# Remove AWS resources
ansible-playbook ansible/playbooks/ansible-cleanup.yml

# Stop Docker
docker-compose down
```

---

## 🎓 Key Concepts Explained

### Infrastructure as Code (IaC)

- Managing infrastructure using code files
- Version controlled like application code
- Repeatable and consistent deployments
- Examples: Terraform, Ansible

### Configuration Management

- Automating server configuration
- Ensuring consistent state
- Examples: Ansible, Chef, Puppet

### Containerization

- Packaging applications with dependencies
- Consistent across environments
- Lightweight and portable
- Examples: Docker, Kubernetes

### Monitoring

- Tracking system health and performance
- Alerting on issues
- Collecting metrics
- Examples: Nagios, Prometheus, Datadog

### Static Website Hosting

- Serving HTML/CSS/JS files
- No server-side processing
- Fast and cheap
- Examples: S3, Netlify, GitHub Pages

---

## 💡 Best Practices

### Docker

- ✅ Use .dockerignore to exclude unnecessary files
- ✅ Use multi-stage builds for smaller images
- ✅ Don't run as root user
- ✅ Use specific image tags, not "latest"

### Ansible

- ✅ Use variables for reusable playbooks
- ✅ Add error handling with ignore_errors
- ✅ Use --check for dry runs
- ✅ Keep playbooks idempotent

### Terraform

- ✅ Use remote state storage
- ✅ Always run terraform plan first
- ✅ Use variables for flexibility
- ✅ Tag all resources
- ✅ Use modules for reusability

### Nagios

- ✅ Set appropriate check intervals
- ✅ Configure notifications properly
- ✅ Monitor critical services only
- ✅ Use service dependencies
- ✅ Regular config backups

---

## 🐛 Troubleshooting

### Docker Issues

```bash
# Container won't start
docker logs e-commerce-dev

# Port already in use
docker ps -a
docker stop <container-id>

# Permission denied
sudo usermod -aG docker $USER
```

### Ansible Issues

```bash
# AWS credentials not found
aws configure

# Playbook syntax error
ansible-playbook --syntax-check playbook.yml

# Connection timeout
# Check AWS credentials and region
```

### Terraform Issues

```bash
# State locked
terraform force-unlock <lock-id>

# Resource already exists
terraform import aws_s3_bucket.website_bucket bucket-name

# Provider plugin error
rm -rf .terraform
terraform init
```

### Nagios Issues

```bash
# Config test failed
sudo nagios4 -v /etc/nagios4/nagios.cfg

# Service not updating
# Force immediate check in web UI

# Can't access dashboard
sudo systemctl status nagios4
sudo systemctl restart apache2
```

---

## 📚 Additional Resources

### Official Documentation

- Docker: https://docs.docker.com
- Ansible: https://docs.ansible.com
- Terraform: https://www.terraform.io/docs
- Nagios: https://www.nagios.org/documentation
- AWS S3: https://docs.aws.amazon.com/s3

### Learning Resources

- Docker Tutorial: https://docker-curriculum.com
- Ansible for DevOps: https://www.ansiblefordevops.com
- Terraform Up & Running: https://www.terraformupandrunning.com
- Nagios Core Tutorial: https://assets.nagios.com/downloads/nagioscore/docs

---

## ✅ Summary

This project demonstrates modern DevOps practices:

1. **Containerization** (Docker) - Package and run applications consistently
2. **Configuration Management** (Ansible) - Automate infrastructure tasks
3. **Infrastructure as Code** (Terraform) - Manage cloud resources declaratively
4. **Monitoring** (Nagios) - Track uptime and performance

Each tool serves a specific purpose and can be used independently or together for a complete deployment and monitoring solution.
