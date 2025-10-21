# Complete E-commerce Project Deployment Guide

## 📋 Project Overview

This document provides a complete step-by-step guide for deploying a static HTML/CSS/JavaScript e-commerce website to AWS using Terraform, Docker, and GitHub Actions CI/CD pipeline.

### 🎯 What We Built

- **Static E-commerce Website**: HTML, CSS, JavaScript (no frameworks)
- **Docker Containerization**: Dockerfile for containerized deployment
- **AWS Infrastructure**: S3 + CloudFront for global hosting
- **Terraform IaC**: Infrastructure as Code for AWS deployment
- **CI/CD Pipeline**: GitHub Actions for automated Docker builds

---

## 🏗️ Project Structure

```
e-commerce-project/
├── index.html                 # Main website page
├── css/                       # Stylesheets
├── js/                        # JavaScript files
├── img/                       # Images and assets
├── Dockerfile                 # Docker configuration
├── .github/
│   └── workflows/
│       └── ci-cd.yml         # GitHub Actions pipeline
├── terraform/
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Terraform variables
│   ├── outputs.tf            # Terraform outputs
│   ├── terraform.tfvars      # Variable values
│   └── .gitignore           # Terraform gitignore
└── README.md                 # Project documentation
```

---

## 🚀 Deployment Options

### Option 1: Local Development

```bash
# Simple HTTP server
python -m http.server 8000
# Then open http://localhost:8000

# Or using Node.js
npx http-server
```

### Option 2: Docker Deployment

```bash
# Build image
docker build -t ecommerce-site .

# Run container
docker run -d --name ecommerce-site -p 8080:80 ecommerce-site
```

### Option 3: AWS Deployment with Terraform (Recommended)

---

## 🔧 Prerequisites for AWS Deployment

### 1. Required Software

- **Terraform**: v1.13.4 or later
- **AWS CLI**: v2.27.40 or later
- **Docker**: For containerization
- **Git**: For version control

### 2. AWS Account Setup

- AWS account with billing enabled
- IAM permissions for S3, CloudFront, and IAM

---

## 🛠️ Step-by-Step AWS Deployment

### Step 1: Install and Configure AWS CLI

#### Install AWS CLI

Download from: https://aws.amazon.com/cli/

#### Configure AWS CLI

```bash
aws configure
```

Enter:

- AWS Access Key ID: [Your Access Key]
- AWS Secret Access Key: [Your Secret Key]
- Default region name: `eu-north-1`
- Default output format: `json`

#### Verify Configuration

```bash
aws configure list
aws sts get-caller-identity
```

### Step 2: Create IAM User (If Needed)

#### AWS Console Steps:

1. Go to AWS Console → IAM → Users
2. Click "Create user"
3. User name: `terraform-user`
4. Access type: Select "Programmatic access" only
5. Permissions: Attach these policies:
   - `AmazonS3FullAccess`
   - `CloudFrontFullAccess`
   - `IAMReadOnlyAccess`
6. Create user and save credentials

### Step 3: Install Terraform

#### Windows Installation:

1. Download from: https://www.terraform.io/downloads
2. Extract to: `C:\Users\[username]\Downloads\terraform_1.13.4_windows_amd64\`
3. Add to PATH or use full path

#### Verify Installation:

```bash
terraform --version
```

### Step 4: Configure Terraform Variables

#### Copy template file:

```bash
cd terraform
copy terraform.tfvars.example terraform.tfvars
```

#### Edit terraform.tfvars:

```hcl
aws_region = "eu-north-1"
bucket_name = "your-unique-bucket-name-here"  # Must be globally unique
environment = "dev"
domain_name = ""  # Optional: your custom domain
certificate_arn = ""  # Optional: SSL certificate ARN
```

**Important**: S3 bucket names must be globally unique across all AWS accounts!

### Step 5: Deploy Infrastructure with Terraform

#### Navigate to terraform directory:

```bash
cd terraform
```

#### Initialize Terraform:

```bash
terraform init
```

#### Review deployment plan:

```bash
terraform plan
```

#### Deploy infrastructure:

```bash
terraform apply
```

**Expected Timeline:**

- S3 Bucket: 1-2 minutes
- CloudFront Distribution: 10-15 minutes
- Total: 15-20 minutes

#### Expected Output:

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

cloudfront_distribution_domain_name = "diuv7jllh15np.cloudfront.net"
cloudfront_distribution_id = "E173I7XBE5QEVB"
s3_bucket_name = "your-bucket-name"
s3_bucket_website_endpoint = "your-bucket-name.s3-website.eu-north-1.amazonaws.com"
s3_website_url = "http://your-bucket-name.s3-website.eu-north-1.amazonaws.com"
website_url = "https://diuv7jllh15np.cloudfront.net"
```

### Step 6: Upload Website Files

#### Upload all website files to S3:

```bash
aws s3 sync . s3://your-bucket-name --exclude "terraform/*" --exclude ".git/*"
```

**Note**: Run this from the project root directory, not the terraform directory.

---

## 🌐 Access Your Website

### Primary URL (CloudFront CDN):

**https://diuv7jllh15np.cloudfront.net**

### Direct S3 URL:

**http://your-bucket-name.s3-website.eu-north-1.amazonaws.com**

### Recommended:

Use the CloudFront URL for better performance and HTTPS support.

---

## 🔄 CI/CD Pipeline Setup

### GitHub Actions Configuration

#### 1. Repository Setup:

- Push your code to a GitHub repository
- Ensure the repository has the `.github/workflows/ci-cd.yml` file

#### 2. Add Secrets to GitHub:

Go to Repository → Settings → Secrets and variables → Actions

Add these secrets:

- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub password

#### 3. Pipeline Triggers:

- **Automatic**: Triggers on every push to `main` branch
- **Manual**: Can be triggered manually from GitHub Actions tab

#### 4. Pipeline Steps:

1. Checkout code
2. Set up Docker Buildx
3. Log in to Docker Hub
4. Build Docker image
5. Push image to Docker Hub

### Pipeline Commands:

```bash
# Build image locally
docker build -t yourusername/ecommerce-site:latest .

# Push to Docker Hub
docker push yourusername/ecommerce-site:latest

# Run from Docker Hub
docker run -d --name ecommerce-site -p 8080:80 yourusername/ecommerce-site:latest
```

---

## 🧹 Cleanup Commands

### Destroy Terraform Infrastructure:

```bash
cd terraform
terraform destroy
```

### Stop Docker Container:

```bash
docker stop ecommerce-site
docker rm ecommerce-site
```

### Remove Docker Image:

```bash
docker rmi ecommerce-site
```

---

## 📊 Infrastructure Details

### AWS Resources Created:

- **S3 Bucket**: Static website hosting
- **S3 Bucket Policy**: Public read access
- **CloudFront Distribution**: Global CDN
- **CloudFront Cache Policy**: Optimized caching

### Terraform Configuration:

- **Provider**: AWS v5.0+
- **Region**: eu-north-1 (Stockholm)
- **SSL**: CloudFront default certificate
- **Caching**: 1 hour default TTL

### Security Features:

- HTTPS enabled via CloudFront
- Public read-only access to S3
- No console access for IAM user
- Programmatic access only

---

## 🔧 Troubleshooting

### Common Issues:

#### 1. "BucketAlreadyExists" Error:

**Problem**: S3 bucket name already exists globally
**Solution**: Use a unique bucket name with your AWS account ID

```hcl
bucket_name = "your-project-name-123456789012"
```

#### 2. "InvalidClientTokenId" Error:

**Problem**: AWS credentials are invalid or expired
**Solution**:

```bash
aws configure
# Enter new credentials
aws sts get-caller-identity
```

#### 3. "terraform: command not found":

**Problem**: Terraform not in PATH
**Solution**: Use full path or add to PATH

```bash
"C:\Users\hp\Downloads\terraform_1.13.4_windows_amd64\terraform.exe" --version
```

#### 4. CloudFront Distribution Taking Long:

**Problem**: CloudFront creation takes 10-15 minutes
**Solution**: This is normal - wait for completion

---

## 📈 Performance Optimization

### CloudFront Benefits:

- **Global Edge Locations**: 400+ locations worldwide
- **SSL/TLS**: Automatic HTTPS
- **Caching**: Reduced origin requests
- **Compression**: Automatic gzip compression

### S3 Benefits:

- **Static Website Hosting**: Direct HTTP access
- **Cost Effective**: Pay-per-use storage
- **Durability**: 99.999999999% (11 9's)
- **Availability**: 99.99%

---

## 💰 Cost Estimation

### AWS Free Tier (First 12 months):

- **S3**: 5GB storage, 20,000 GET requests
- **CloudFront**: 1TB data transfer, 10,000,000 requests
- **Total**: ~$0/month for small websites

### Beyond Free Tier:

- **S3**: $0.023 per GB per month
- **CloudFront**: $0.085 per GB data transfer
- **Total**: ~$1-5/month for moderate traffic

---

## 🔄 Maintenance and Updates

### Update Website Content:

```bash
# Make changes to your website files
# Then sync to S3
aws s3 sync . s3://your-bucket-name --exclude "terraform/*" --exclude ".git/*"
```

### Update Infrastructure:

```bash
cd terraform
# Modify .tf files as needed
terraform plan
terraform apply
```

### Monitor Resources:

- **AWS Console**: Check S3 and CloudFront usage
- **CloudWatch**: Monitor performance metrics
- **Terraform**: Track infrastructure changes

---

## 📚 Additional Resources

### Documentation Links:

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Getting Started](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GettingStarted.html)
- [GitHub Actions](https://docs.github.com/en/actions)

### Useful Commands Reference:

```bash
# AWS CLI
aws configure list
aws sts get-caller-identity
aws s3 ls
aws s3 sync . s3://bucket-name

# Terraform
terraform init
terraform plan
terraform apply
terraform destroy
terraform output

# Docker
docker build -t image-name .
docker run -d -p 8080:80 image-name
docker ps
docker logs container-name
```

---

## ✅ Project Completion Checklist

- [ ] AWS CLI configured
- [ ] IAM user created with proper permissions
- [ ] Terraform installed and working
- [ ] terraform.tfvars configured with unique bucket name
- [ ] Infrastructure deployed successfully
- [ ] Website files uploaded to S3
- [ ] Website accessible via CloudFront URL
- [ ] CI/CD pipeline configured (optional)
- [ ] Documentation completed

---

## 🎉 Final Result

Your e-commerce website is now live with:

- **Global CDN**: Fast loading worldwide
- **HTTPS Security**: SSL certificate enabled
- **Professional Infrastructure**: AWS best practices
- **Scalable Architecture**: Handles traffic spikes
- **Cost Effective**: Pay-per-use pricing
- **Easy Maintenance**: Infrastructure as Code

**Website URL**: https://diuv7jllh15np.cloudfront.net

---

_This guide provides everything needed to deploy, maintain, and scale your e-commerce website on AWS using modern DevOps practices._
