#!/bin/bash
set -eux

# 시스템 업데이트 및 Docker 설치
apt-get update && apt-get upgrade -y
apt-get install -y docker.io docker-compose git

# 사용자 계정 추가 및 Docker 실행 권한 부여
usermod -aG docker ubuntu
newgrp docker

# Git 저장소 클론 또는 업데이트
cd /home/ubuntu
if [ -d "nebula-ai" ]; then
    cd nebula-ai && git pull origin dev
else
    git clone -b dev https://github.com/TU-NEBULA/nebula-ai.git
    cd nebula-ai
fi

# 환경 변수 파일 생성
echo "${DEV_ENV_FILE}" > .env

# 인스턴스 역할에 따라 적절한 docker-compose 실행
if [ "$ROLE" == "fastapi" ]; then
    docker-compose -f docker-compose.fastapi.dev.yml up -d --build
elif [ "$ROLE" == "celery" ]; then
    docker-compose -f docker-compose.celery.dev.yml up -d --build
elif [ "$ROLE" == "chroma" ]; then
    docker-compose -f docker-compose.chroma.dev.yml up -d --build
fi

echo "Docker Compose 실행 완료"
