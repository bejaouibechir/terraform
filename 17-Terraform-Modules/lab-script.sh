#!/usr/bin/env bash
# ============================================================
# Lab 17 - Terraform Modules
# ============================================================

# Initialize and download declared modules
terraform init

# Format files in the modules directory too
terraform fmt -recursive

# Validate Terraform syntax
terraform validate

# In the plan, observe resources prefixed with module.vpc_dev.*, module.ec2_dev.*, and module.s3_dev.*
terraform plan

# Create resources for the composed modules
terraform apply -auto-approve

# Show module outputs
terraform output

# Resources are prefixed with module.<name>.* in state
terraform state list

# Destroy all resources for cleanup
terraform destroy -auto-approve
