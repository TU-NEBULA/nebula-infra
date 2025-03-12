# FastAPI 보안 그룹
resource "aws_security_group" "fastapi_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8000  
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: 보안 강화를 위해 특정 IP만 허용 가능
  }

  tags = {
    Name = "fastapi-sg"
  }
}

# Spring Boot 보안 그룹 (추후 추가)
resource "aws_security_group" "springboot_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: 보안 강화를 위해 특정 IP만 허용 가능
  }

  tags = {
    Name = "springboot-sg"
  }
}

resource "aws_security_group" "celery_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5672  # RabbitMQ 포트
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: 보안 강화를 위해 내부 통신만 허용 가능
  }

  tags = {
    Name = "celery-sg"
  }
}

resource "aws_security_group" "chroma_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: 보안 강화를 위해 특정 IP만 허용 가능
  }

  tags = {
    Name = "chroma-sg"
  }
}

resource "aws_security_group" "ssh_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # TODO: 보안 강화를 위해 특정 IP만 허용 가능
  }

  tags = {
    Name = "ssh-sg"
  }
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fastapi_sg.id  # FastAPI
}

resource "aws_security_group_rule" "allow_all_outbound_celery" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.celery_sg.id  # Celery
}

resource "aws_security_group_rule" "allow_all_outbound_chroma" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.chroma_sg.id  # ChromaDB
}
