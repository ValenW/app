#!/bin/bash

# 定义镜像名称和容器名称
IMAGE_NAME="lobehub/lobe-chat-database"
CONTAINER_NAME="lobe"

# 定义检查和更新的函数
update_docker_image() {
  echo "Checking for updates to the image: $IMAGE_NAME"

  # 拉取最新镜像
  if docker pull $IMAGE_NAME; then
    echo "Successfully pulled the latest image: $IMAGE_NAME"

    # 检查当前容器状态
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
      echo "Restarting the existing container: $CONTAINER_NAME"
      # 使用docker-compose重启指定服务
      docker-compose up -d --no-deps --remove-orphans $CONTAINER_NAME
    else
      echo "No running container found for: $CONTAINER_NAME"
      # 如果没有运行的容器，直接启动服务
      docker-compose up -d $CONTAINER_NAME
    fi

  else
    echo "Failed to pull the image: $IMAGE_NAME"
  fi
}

# 主循环
while true; do
  update_docker_image
  echo "Waiting for 5 minutes before checking again..."
  sleep 300 # 5分钟（300秒）
done
