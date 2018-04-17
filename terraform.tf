terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "giancarlo-petrini-s3-state-bucket"
    dynamodb_table = "dynamodb-terraform-state-lock"
    region         = "us-east-1"
    key            = "terraform.tfstate"
    profile        = "tfbuild"
  }
}
