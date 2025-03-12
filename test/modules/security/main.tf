# FastAPI 보안 그룹
resource "aws_security_group" "fastapi_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8000  
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Spring Boot 보안 그룹 (추후 추가)
resource "aws_security_group" "springboot_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

