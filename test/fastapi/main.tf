provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "fastapi_servers" {
  count         = 3
  ami           = "ami-024ea438ab0376a47"  
  instance_type = var.instance_type
  availability_zone = "ap-northeast-2a"  
  subnet_id     = module.vpc.public_subnet_id  

  tags = {
    Name = element(["fastapi", "celery", "chroma"], count.index)
    Role = element(["FastAPI", "Celery", "Chroma"], count.index)
  }
}

module "vpc" {
  source = "../modules/vpc"
}
