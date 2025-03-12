set -eux

# 추가된 EBS 볼륨 확인 및 마운트
if [ "$(lsblk | grep xvdi)" ]; then
    sudo mkfs -t ext4 /dev/xvdi
    sudo mkdir -p /mnt/chroma
    sudo mount /dev/xvdi /mnt/chroma
    echo "/dev/xvdi /mnt/chroma ext4 defaults,nofail 0 2" >> /etc/fstab
    echo "Chroma 추가 볼륨 마운트 완료"
fi

if [ "$(lsblk | grep xvdh)" ]; then
    sudo mkfs -t ext4 /dev/xvdh
    sudo mkdir -p /mnt/fastapi
    sudo mount /dev/xvdh /mnt/fastapi
    echo "/dev/xvdh /mnt/fastapi ext4 defaults,nofail 0 2" >> /etc/fstab
    echo "FastAPI 추가 볼륨 마운트 완료"
fi

echo "추가 볼륨 설정 완료"

# Docker 및 Docker Compose 설치
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

echo "Docker 및 Docker Compose 설치 완료"
