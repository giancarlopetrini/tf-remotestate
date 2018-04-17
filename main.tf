variable "aws_cli_profile" {}
variable "iam_account" {}
variable "state_bucket" {}

provider "aws" {
  region  = "us-east-1"
  profile = "${var.aws_cli_profile}"
}

resource "aws_instance" "firstec2" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"

  tags {
    Name = "SampleEC2"
  }
}

resource "aws_s3_bucket" "terraform-state" {
  bucket        = "${var.state_bucket}"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags {
    Name = "${var.state_bucket}"
  }
}

resource "aws_s3_bucket_policy" "terraform-state" {
  bucket = "${aws_s3_bucket.terraform-state.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [{
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.iam_account}:user/${var.aws_cli_profile}"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${var.state_bucket}"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.iam_account}:user/${var.aws_cli_profile}"
            },
            "Action": ["s3:GetObject", "s3:PutObject"],
            "Resource": "arn:aws:s3:::${var.state_bucket}/terraform.tfstate"
        }
    ]
}
POLICY
}

resource "aws_dynamodb_table" "dynamodb-terraform-state" {
  name           = "dynamodb-terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "dynamoDB-terraform-state-lock-table"
  }
}
