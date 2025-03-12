provider "aws" {
  region = "ap-northeast-2"
}

data "aws_key_pair" "existing_key" {
  key_name = "nebula-pem-key"
}

resource "aws_instance" "nebula_ai" {
  ami           = "ami-024ea438ab0376a47"
  instance_type = var.instance_type
  availability_zone = "ap-northeast-2a"
  subnet_id     = module.vpc.public_subnet_id
  key_name      = data.aws_key_pair.existing_key.key_name

  vpc_security_group_ids = [
    module.security.ssh_sg_id,
    module.security.fastapi_sg_id
  ]

  tags = {
    Name = "nebula-ai"
  }

  root_block_device {
    volume_size = 20 
    volume_type = "gp3"
  }

  user_data = file("${path.module}/scripts/setup.sh")
  user_data_replace_on_change = true
}

resource "aws_ebs_volume" "nebula_extra_ebs" {
  availability_zone = "ap-northeast-2a"
  size             = 20
  tags = {
    Name = "nebula-extra-volume"
  }
}

resource "aws_volume_attachment" "nebula_extra_attach" {
  device_name = "/dev/xvdi"
  volume_id   = aws_ebs_volume.nebula_extra_ebs.id
  instance_id = aws_instance.nebula_ai.id
}

resource "aws_eip" "nebula_ai_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "nebula_ai_eip_assoc" {
  instance_id   = aws_instance.nebula_ai.id
  allocation_id = aws_eip.nebula_ai_eip.id
}

module "vpc" {
  source = "../modules/vpc"
}

module "security" {
  source = "../modules/security"
  vpc_id = module.vpc.vpc_id 
}
