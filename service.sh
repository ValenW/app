#!/bin/bash

# Define an array of service directories in the order they should be managed
services=("." "memo" "webhook" "lib-search-server")

# Initialize an empty array to keep track of started services
started_services=()

# Function to bring up services
up_services() {
  for service in "${services[@]}"; do
    echo "Bringing up $service..."
    cd "$service" || { echo "Failed to navigate to $service directory"; rollback; exit 1; }
    docker-compose up -d || { echo "Failed to bring up $service"; rollback; exit 1; }
    started_services+=("$service")
    cd - >/dev/null || { echo "Failed to navigate back to root directory"; rollback; exit 1; }
  done
  echo "All services are up!"
}

# Function to bring down services
down_services() {
  # Reverse the services array manually
  reversed_services=()
  for (( i=${#services[@]}-1 ; i>=0 ; i-- )); do
    reversed_services+=("${services[i]}")
  done
  
  for service in "${reversed_services[@]}"; do
    echo "Bringing down $service..."
    cd "$service" || { echo "Failed to navigate to $service directory"; exit 1; }
    docker-compose down || { echo "Failed to bring down $service"; exit 1; }
    cd - >/dev/null || { echo "Failed to navigate back to root directory"; exit 1; }
  done
  echo "All services are down!"
}

# Rollback function to undo the previous commands
rollback() {
  echo "An error occurred. Rolling back started services..."
  for service in "${started_services[@]}"; do
    echo "Rolling back $service..."
    cd "$service" || { echo "Failed to navigate to $service directory"; exit 1; }
    docker-compose down || { echo "Failed to roll back $service"; exit 1; }
    cd - >/dev/null || { echo "Failed to navigate back to root directory"; exit 1; }
  done
}

# Check the first argument passed to the script
if [ "$1" == "up" ]; then
  up_services
elif [ "$1" == "down" ]; then
  down_services
else
  echo "Usage: $0 {up|down}"
  exit 1
fi
