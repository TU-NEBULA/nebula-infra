provider "aws" {
  region = "ap-northeast-2"
}

data "aws_key_pair" "existing_key" {
  key_name = "nebula-pem-key"
}

resource "aws_instance" "fastapi_servers" {
  count         = 3
  ami           = "ami-024ea438ab0376a47"  
  instance_type = var.instance_type
  availability_zone = "ap-northeast-2a"  
  subnet_id     = module.vpc.public_subnet_id  
  key_name      = data.aws_key_pair.existing_key.key_name

  vpc_security_group_ids = [
    module.security.ssh_sg_id,
    count.index == 0 ? module.security.fastapi_sg_id :
    count.index == 1 ? module.security.celery_sg_id :
    module.security.chroma_sg_id
  ]

  tags = {
    Name = "nebula-ai-${element(["fastapi", "celery", "chroma"], count.index)}"
    Role = element(["FastAPI", "Celery", "Chroma"], count.index)
  }

  root_block_device {
    volume_size = count.index == 2 ? 20 : count.index == 0 ? 10 : 8  # ✅ Chroma(20GB), FastAPI(10GB), Celery(8GB 기본값)
  }

  user_data = file("${path.module}/scripts/setup_docker.sh")
  user_data_replace_on_change = true
}

# ✅ FastAPI용 추가 EBS 볼륨 (10GB)
resource "aws_ebs_volume" "fastapi_ebs" {
  availability_zone = "ap-northeast-2a"
  size             = 10
  tags = {
    Name = "fastapi-extra-volume"
  }
}

resource "aws_volume_attachment" "fastapi_attach" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.fastapi_ebs.id
  instance_id = aws_instance.fastapi_servers[0].id
}

# ✅ Chroma용 추가 EBS 볼륨 (20GB)
resource "aws_ebs_volume" "chroma_ebs" {
  availability_zone = "ap-northeast-2a"
  size             = 20
  tags = {
    Name = "chroma-extra-volume"
  }
}

resource "aws_volume_attachment" "chroma_attach" {
  device_name = "/dev/xvdi"
  volume_id   = aws_ebs_volume.chroma_ebs.id
  instance_id = aws_instance.fastapi_servers[2].id
}

resource "aws_eip" "fastapi_eip" {
  domain = "vpc"
}

resource "aws_eip" "celery_eip" {
  domain = "vpc"
}

resource "aws_eip" "chroma_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "fastapi_eip_assoc" {
  instance_id   = aws_instance.fastapi_servers[0].id
  allocation_id = aws_eip.fastapi_eip.id
}

resource "aws_eip_association" "celery_eip_assoc" {
  instance_id   = aws_instance.fastapi_servers[1].id
  allocation_id = aws_eip.celery_eip.id
}

resource "aws_eip_association" "chroma_eip_assoc" {
  instance_id   = aws_instance.fastapi_servers[2].id
  allocation_id = aws_eip.chroma_eip.id
}

module "vpc" {
  source = "../modules/vpc"
}

module "security" {
  source = "../modules/security"
  vpc_id = module.vpc.vpc_id 
}
