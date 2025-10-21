# E-Commerce Project

Hi, this project is a fully responsive e-commerce website project made only HTML, CSS and JavaScript.

No framework or library (except glide.js) was used throughout the project.

## Running the Project

### Local Development

```bash
# Simple HTTP server
python -m http.server 8000
# Then open http://localhost:8000

# Or using Node.js
npx http-server
```

### Docker

```bash
# Build image
docker build -t ecommerce-site .

# Run container
docker run -d --name ecommerce-site -p 8080:80 ecommerce-site
```

### AWS Deployment with Terraform

#### Prerequisites

- Terraform installed
- AWS CLI configured with credentials
- AWS account with appropriate permissions

#### Setup

1. Copy terraform variables file:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your values:

```hcl
aws_region = "us-east-1"
bucket_name = "your-unique-bucket-name-here"
environment = "dev"
```

#### Deploy

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

#### Upload Website Files

After deployment, upload your website files to the S3 bucket:

```bash
aws s3 sync ../ s3://your-bucket-name --exclude "terraform/*" --exclude ".git/*"
```

#### Access Your Website

- CloudFront URL: Check terraform outputs for the distribution URL
- S3 Direct URL: Check terraform outputs for the S3 website endpoint

#### Cleanup

```bash
terraform destroy
```

## CI/CD Pipeline

The project includes GitHub Actions workflow for automated Docker builds and deployment to Docker Hub.

### Setup

1. Add these secrets to your GitHub repository:

   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password

2. Push to main branch to trigger the pipeline

## Live Demo

You can reach the live link of the project from the link below.

Link : https://commerce-project.netlify.app/
