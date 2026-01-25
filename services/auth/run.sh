#!/bin/bash

# ==================== Lemon Korean Auth Service - Docker Run Script ====================
# This script runs the Docker container for the auth service

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="lemon-auth-service"
IMAGE_TAG="${1:-latest}"
CONTAINER_NAME="lemon-auth"
PORT="3001"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Running Auth Service Container${NC}"
echo -e "${GREEN}========================================${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if image exists
if ! docker images ${IMAGE_NAME}:${IMAGE_TAG} | grep -q ${IMAGE_TAG}; then
    echo -e "${RED}Error: Image ${IMAGE_NAME}:${IMAGE_TAG} not found${NC}"
    echo -e "${YELLOW}Please run ./build.sh first${NC}"
    exit 1
fi

# Stop and remove existing container if exists
if docker ps -a | grep -q ${CONTAINER_NAME}; then
    echo -e "${YELLOW}Stopping and removing existing container...${NC}"
    docker rm -f ${CONTAINER_NAME} > /dev/null 2>&1
    echo -e "${GREEN}✓ Removed existing container${NC}"
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Warning: .env file not found${NC}"
    read -p "Continue without .env file? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Aborted${NC}"
        exit 1
    fi
    ENV_FILE_ARG=""
else
    ENV_FILE_ARG="--env-file .env"
    echo -e "${GREEN}✓ Found .env file${NC}"
fi

# Ask for run mode
echo ""
echo -e "${BLUE}Select run mode:${NC}"
echo "1) Foreground (with logs)"
echo "2) Background (detached)"
read -p "Choice (1-2): " -n 1 -r
echo

if [[ $REPLY == "1" ]]; then
    DETACH_ARG=""
    echo -e "${YELLOW}Running in foreground mode. Press Ctrl+C to stop.${NC}"
else
    DETACH_ARG="-d"
    echo -e "${GREEN}Running in background mode${NC}"
fi

# Run the container
echo ""
echo -e "${GREEN}Starting container...${NC}"
echo ""

CONTAINER_ID=$(docker run ${DETACH_ARG} \
    --name ${CONTAINER_NAME} \
    -p ${PORT}:${PORT} \
    ${ENV_FILE_ARG} \
    ${IMAGE_NAME}:${IMAGE_TAG})

if [ -n "${DETACH_ARG}" ]; then
    # Background mode
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✓ Container started successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${YELLOW}Container ID:${NC} ${CONTAINER_ID:0:12}"
    echo -e "${YELLOW}Container Name:${NC} ${CONTAINER_NAME}"
    echo -e "${YELLOW}Port:${NC} ${PORT}"
    echo ""

    # Wait for container to be ready
    echo -e "${YELLOW}Waiting for service to start...${NC}"
    sleep 3

    # Check health
    if docker ps | grep -q ${CONTAINER_NAME}; then
        echo -e "${GREEN}✓ Container is running${NC}"

        # Try to access health endpoint
        echo ""
        echo -e "${YELLOW}Testing health endpoint...${NC}"
        if curl -s -f http://localhost:${PORT}/health > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Service is healthy${NC}"
        else
            echo -e "${YELLOW}! Health check not responding yet (this is normal)${NC}"
            echo -e "${YELLOW}  Service may need more time to start${NC}"
        fi

        # Display useful commands
        echo ""
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}Useful Commands:${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo ""
        echo -e "${YELLOW}View logs:${NC}"
        echo "  docker logs -f ${CONTAINER_NAME}"
        echo ""
        echo -e "${YELLOW}Check status:${NC}"
        echo "  docker ps | grep ${CONTAINER_NAME}"
        echo ""
        echo -e "${YELLOW}Stop container:${NC}"
        echo "  docker stop ${CONTAINER_NAME}"
        echo ""
        echo -e "${YELLOW}Access shell:${NC}"
        echo "  docker exec -it ${CONTAINER_NAME} sh"
        echo ""
        echo -e "${YELLOW}Test API:${NC}"
        echo "  curl http://localhost:${PORT}/health"
        echo "  curl http://localhost:${PORT}/"
        echo ""
    else
        echo -e "${RED}✗ Container failed to start${NC}"
        echo ""
        echo -e "${YELLOW}View logs with:${NC}"
        echo "  docker logs ${CONTAINER_NAME}"
        exit 1
    fi
else
    # Foreground mode - logs will be displayed
    echo -e "${YELLOW}Container stopped${NC}"
fi
