terraform {
  backend "s3" {
    bucket         = "cloudguru-terraform-state-2025"
    key            = "infra/terraform.tfstate"
    region         = "us-east-2"	
    dynamodb_table = "terraform-locks"
     encrypt        = true
  }
}
