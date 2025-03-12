terraform {
  backend "s3" {
    bucket         = "nebula-terraform-state-seoul"  
    key            = "test/fastapi/terraform.tfstate"  
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock"  
  }
}
