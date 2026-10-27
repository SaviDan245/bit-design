#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Использование: $0 <registry/имя образа> [тег]"
    echo "Пример: $0 docker.io/username/health-app 1.0.0"
    exit 1
fi

IMAGE=$1
TAG=${2:-1.0.0}

cd "$(dirname "$0")"

docker build -t "$IMAGE:$TAG" .
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось собрать образ $IMAGE:$TAG"
    exit 1
fi

docker push "$IMAGE:$TAG"
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось выгрузить образ $IMAGE:$TAG в registry"
    exit 1
fi

echo "Образ $IMAGE:$TAG собран и выгружен в registry"
