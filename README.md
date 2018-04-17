# tf-remotestate

### Quick sample for setting up remote state in Terraform

1. Create terraform.tfvars file and enter AWS info (bucket name, AWS CLI profile, IAM Account Number)
2. Update terraform.tf file with proper S3 bucket name and AWS profile info, then `/* .... */` comment out whole file (temporarily)
3. `terraform init`
4. `terraform apply`
5. Uncomment terraform.tf file, and run `terraform init` once more