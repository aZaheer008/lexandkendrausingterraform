
# Project Title
LexKendraBot

This is the terrafrom script to create lexbot and kendraindex , and then integrate lexbot with kendra to answer the questions .

# Deployment Steps
We are given the instruction for cloud9

# Cloud9 Setup
Create environment

# Terraform Backend Configuration
Before moving on to Cloud9, let's talk about Terraform Backend Configuration. We have been maintaining our Terraform state on our local machine. However, this won't scale in a collaborative environment. Instead, we can specify a backend that defines where Terraform stores its state data files.

A backend defines where Terraform stores its state data files. For example, we can change from the default local backend to an s3 backend.
```
  backend "s3" {
    bucket = "terraform-state-aws-by-example"
    key    = "main/terraform.tfstate"
    region = "us-east-1"
  }
```

place this object in terraform object in providers.tf file , Your profile will be like 

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8"
    }
  }
  backend "s3" {
    bucket = "terraform-state-aws-by-example"
    key    = "main/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

The archive provider will expose resources to manage archive files.
provider "archive" {}

```

craete bucket with any unique name , above we used "terraform-state-aws-by-example"
by using this command You can cereate bucket by terminal
aws s3 mb s3://YOUR_BUCKET_NAME

1. Navigate to your AWS console and search for Cloud9
2. Click on the Create environment button
3. Provide a name for your environment
4. Click next and make sure to select at least the following settings just to make sure we work with the same settings
    a. Enviorment Type
        create a new EC2 instance for enviorment (direct access)
    b. Instance Type
        t2.micro (1 GIB RAM + 1 vCPU)
    c. Platform
        Ubuntu server
5. Proceed with all the remaining steps and create your environment. Creation process may take a few minutes.

# Git Setup

Next, we need to pull in our code from a code repository. In my case, I'm using GitHub, so my instructions will be more specific towards GitHub.

# Clone Code Repository
AWS Cloud9 EC2 environments come preinstalled with Git. Trying cloning the repository that has your work to this point, you will get permissions issues.

# GitHub setup for ssh access
While in your Cloud9 terminal, run the following commands

1. Generate RSA key pair, run below command in Your terminal
ssh-keygen -t rsa

2. Hit enter on all steps until you get
3. Copy your Public Key to your GitHub account in your Cloud9 terminal,run this command "cat /home/ubuntu/.ssh/id_rsa.pub" to output the public key. 
Go to your https://github.com/settings/keys page and click New SSH key
4. Try cloning the repo again and you should be successful

# Terraform init
Cloud9 environment also comes with Terraform preinstalled.

Remember, on the local machine; we used an AWS credentials profile to enable Terraform to access our AWS resources. However, with Cloud9, we don't need that anymore because the terminal includes sudo privileges to the managed Amazon EC2 instance that hosts our development environment.

AWS Cloud9 makes temporary AWS access credentials available when we use AWS Cloud9 EC2 development environment. However, you will need to check the Actions supported by AWS managed temporary credentials. In our case of AWS Cloud9 EC2 development environment we have some limitations.

Go to Cloud9 -> Preferences -> AWS Settings and turn off AWS managed temporary credentials

Store your permanent AWS access credentials in the environment. This is similar to what we did earlier by running theaws configure command. See Create and store permanent access credentials in an Environment.

1. Run terraform init command since we are starting fresh with the environment Make sure you are in the root of your cloned project.
2. Run terraform plan to check the resources that will be provisioned.
3. Running terraform plan should succeed .

Run terraform apply again, and after accepting the plan, your resources will be created successfully.
