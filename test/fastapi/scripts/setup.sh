#!/bin/bash
set -eux

echo "setup.sh 실행 시작" | sudo tee -a /var/log/setup.log

# 추가된 EBS 볼륨 확인 및 마운트
if lsblk | grep -q xvdi; then
    sudo mkfs -t ext4 /dev/xvdi
    sudo mkdir -p /mnt/chroma
    sudo mount /dev/xvdi /mnt/chroma
    echo "/dev/xvdi /mnt/chroma ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
    echo "Chroma 추가 볼륨 마운트 완료" | sudo tee -a /var/log/setup.log
fi

# Docker 및 Docker Compose 설치
echo "Docker 설치 시작" | sudo tee -a /var/log/setup.log
sudo apt-get update 
sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
newgrp docker

echo "Docker 및 Docker Compose 설치 완료" | sudo tee -a /var/log/setup.log
echo "setup.sh 실행 완료" | sudo tee -a /var/log/setup.log
