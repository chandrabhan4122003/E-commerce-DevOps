# Complete AWS & Terraform Command Reference Guide

## 📋 Overview

This document contains all the AWS CLI and Terraform commands used in our DevOps project deployment. Perfect for studying and future reference.

---

## 🔧 AWS CLI Commands

### **Installation & Configuration**

#### Check AWS CLI Version

```bash
aws --version
```

**Output**: `aws-cli/2.27.40 Python/3.13.4 Windows/11 exe/AMD64`

#### Configure AWS CLI

```bash
aws configure
```

**Enter**:

- AWS Access Key ID: [Your Access Key]
- AWS Secret Access Key: [Your Secret Key]
- Default region name: `eu-north-1`
- Default output format: `json`

#### Check Current Configuration

```bash
aws configure list
```

**Output**:

```
Name                    Value             Type    Location
----                    -----             ----    --------
profile                <not set>             None    None
access_key     ******************** shared-credentials-file
secret_key     ******************** shared-credentials-file
region               eu-north-1      config-file    ~/.aws/config
```

#### Test AWS Connection

```bash
aws sts get-caller-identity
```

**Success Output**:

```json
{
  "UserId": "AIDACKCEVSQ6C2EXAMPLE",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/terraform-user"
}
```

### **S3 Commands**

#### List S3 Buckets

```bash
aws s3 ls
```

#### Upload Website Files to S3

```bash
aws s3 sync . s3://your-bucket-name --exclude "terraform/*" --exclude ".git/*"
```

**Example**:

```bash
aws s3 sync D:\DevopsProject\e-commerce-project s3://your-unique-bucket-name --exclude "terraform/*" --exclude ".git/*"
```

#### Empty S3 Bucket (for cleanup)

```bash
aws s3 rm s3://bucket-name --recursive
```

**Example**:

```bash
aws s3 rm s3://your-unique-bucket-name --recursive
```

#### Check S3 Bucket Contents

```bash
aws s3 ls s3://bucket-name
```

---

## 🏗️ Terraform Commands

### **Installation & Verification**

#### Check Terraform Version

```bash
terraform --version
```

**Output**: `Terraform v1.13.4 on windows_amd64`

#### Using Full Path (Windows)

```bash
& "C:\Users\hp\Downloads\terraform_1.13.4_windows_amd64\terraform.exe" --version
```

### **Basic Terraform Workflow**

#### Navigate to Terraform Directory

```bash
cd terraform
```

#### Initialize Terraform

```bash
terraform init
```

**Output**:

```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.100.0...
```

#### Review Deployment Plan

```bash
terraform plan
```

**Shows**: What resources will be created/modified/destroyed

#### Deploy Infrastructure

```bash
terraform apply
```

**Interactive**: Type `yes` when prompted

#### Deploy with Auto-Approval

```bash
terraform apply -auto-approve
```

#### Show Current State

```bash
terraform show
```

#### List Resources

```bash
terraform state list
```

#### View Outputs

```bash
terraform output
```

#### Refresh State

```bash
terraform refresh
```

### **Cleanup Commands**

#### Destroy Infrastructure

```bash
terraform destroy
```

**Interactive**: Type `yes` when prompted

#### Destroy with Auto-Approval

```bash
terraform destroy -auto-approve
```

#### Force Unlock (if needed)

```bash
terraform force-unlock LOCK_ID
```

---

## 📁 File Management Commands

### **Copy Configuration Files**

```bash
copy terraform.tfvars.example terraform.tfvars
```

### **Navigate Directories**

```bash
# Go to project root
cd D:\DevopsProject\e-commerce-project

# Go to terraform directory
cd terraform

# Go back one level
cd ..
```

---

## 🐳 Docker Commands (Bonus)

### **Build Docker Image**

```bash
docker build -t ecommerce-site .
```

### **Run Docker Container**

```bash
docker run -d --name ecommerce-site -p 8080:80 ecommerce-site
```

### **Stop Container**

```bash
docker stop ecommerce-site
```

### **Remove Container**

```bash
docker rm ecommerce-site
```

### **Remove Image**

```bash
docker rmi ecommerce-site
```

---

## 🔄 Git Commands Used

### **Check Status**

```bash
git status
```

### **Add All Files**

```bash
git add .
```

### **Commit Changes**

```bash
git commit -m "Complete DevOps setup: Added Terraform, Docker, GitHub Actions, and comprehensive documentation"
```

### **Push to Repository**

```bash
git push origin main
```

---

## 📊 Expected Outputs & Results

### **Terraform Apply Success Output**

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

cloudfront_distribution_domain_name = "d1234567890abc.cloudfront.net"
cloudfront_distribution_id = "E1234567890ABC"
s3_bucket_name = "your-unique-bucket-name"
s3_bucket_website_endpoint = "your-unique-bucket-name.s3-website.eu-north-1.amazonaws.com"
s3_website_url = "http://your-unique-bucket-name.s3-website.eu-north-1.amazonaws.com"
website_url = "https://d1234567890abc.cloudfront.net"
```

### **S3 Sync Success Output**

```
Completed 3.6 MiB/3.6 MiB (858.2 KiB/s) with 1 file(s) remaining
upload: ..\README.md to s3://your-unique-bucket-name/README.md
```

### **Terraform Destroy Success Output**

```
Destroy complete! Resources: 1 destroyed.
```

---

## ⚠️ Common Error Messages & Solutions

### **"BucketAlreadyExists" Error**

```bash
Error: creating S3 Bucket: operation error S3: CreateBucket, https response error StatusCode: 409, RequestID: BDY8VAZDR3KTF8GP, api error BucketAlreadyExists
```

**Solution**: Use a unique bucket name with your AWS account ID

### **"InvalidClientTokenId" Error**

```bash
Error: InvalidClientTokenId: The security token included in the request is invalid.
```

**Solution**: Reconfigure AWS CLI with valid credentials

```bash
aws configure
aws sts get-caller-identity
```

### **"terraform: command not found"**

```bash
terraform : The term 'terraform' is not recognized
```

**Solution**: Use full path or add to PATH

```bash
& "C:\Users\hp\Downloads\terraform_1.13.4_windows_amd64\terraform.exe" --version
```

### **"BucketNotEmpty" Error**

```bash
Error: deleting S3 Bucket: operation error S3: DeleteBucket, api error BucketNotEmpty: The bucket you tried to delete is not empty
```

**Solution**: Empty bucket first, then destroy

```bash
aws s3 rm s3://bucket-name --recursive
terraform destroy
```

---

## 🎯 Complete Deployment Workflow

### **Full Deployment Sequence**

```bash
# 1. Navigate to terraform directory
cd terraform

# 2. Initialize Terraform
terraform init

# 3. Review plan
terraform plan

# 4. Deploy infrastructure
terraform apply

# 5. Upload website files (from project root)
cd ..
aws s3 sync . s3://your-bucket-name --exclude "terraform/*" --exclude ".git/*"

# 6. Access your website
# CloudFront URL: https://your-cloudfront-domain.cloudfront.net
```

### **Complete Cleanup Sequence**

```bash
# 1. Empty S3 bucket
aws s3 rm s3://your-bucket-name --recursive

# 2. Destroy infrastructure
cd terraform
terraform destroy

# 3. Commit final state
cd ..
git add .
git commit -m "AWS infrastructure destroyed"
git push origin main
```

---

## 📚 Key Configuration Files

### **terraform.tfvars**

```hcl
aws_region = "eu-north-1"
bucket_name = "your-unique-bucket-name-here"
environment = "dev"
domain_name = ""
certificate_arn = ""
```

### **main.tf** (Key Resources)

- S3 bucket for website hosting
- S3 bucket policy for public access
- CloudFront distribution for CDN
- Website configuration

---

## 🔍 Monitoring & Verification Commands

### **Check Website Accessibility**

```bash
# Test CloudFront URL
curl -I https://your-cloudfront-domain.cloudfront.net

# Test S3 direct URL
curl -I http://your-bucket-name.s3-website.eu-north-1.amazonaws.com
```

### **Check AWS Resources**

```bash
# List all S3 buckets
aws s3 ls

# Check CloudFront distributions
aws cloudfront list-distributions

# Verify IAM user
aws sts get-caller-identity
```

---

## 💡 Pro Tips for Studying

1. **Practice Order**: Always run commands in the exact sequence shown
2. **Error Handling**: Study the common error messages and their solutions
3. **Output Reading**: Learn to interpret Terraform plan and apply outputs
4. **State Management**: Understand how Terraform tracks resource state
5. **Cost Management**: Always destroy resources when done to avoid charges

---

## 🎓 Study Checklist

- [ ] Understand AWS CLI configuration process
- [ ] Master Terraform basic workflow (init → plan → apply → destroy)
- [ ] Know how to handle common errors
- [ ] Practice S3 file management commands
- [ ] Learn to read Terraform outputs
- [ ] Understand Git workflow for DevOps projects
- [ ] Know cleanup procedures to avoid costs

---

_This command reference covers everything we used in our DevOps project. Perfect for review and future deployments!_
