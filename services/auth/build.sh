#!/bin/bash

# ==================== Lemon Korean Auth Service - Docker Build Script ====================
# This script builds the Docker image for the auth service

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="lemon-auth-service"
IMAGE_TAG="${1:-latest}"
BUILD_ARGS=""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Building Auth Service Docker Image${NC}"
echo -e "${GREEN}========================================${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "Dockerfile" ]; then
    echo -e "${RED}Error: Dockerfile not found. Please run this script from services/auth directory${NC}"
    exit 1
fi

# Display build information
echo -e "${YELLOW}Image Name:${NC} ${IMAGE_NAME}"
echo -e "${YELLOW}Image Tag:${NC} ${IMAGE_TAG}"
echo ""

# Ask for build options
read -p "Use BuildKit for faster builds? (Y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    export DOCKER_BUILDKIT=1
    echo -e "${GREEN}✓ BuildKit enabled${NC}"
fi

read -p "Build without cache? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    BUILD_ARGS="--no-cache"
    echo -e "${YELLOW}! Building without cache${NC}"
fi

# Start build
echo ""
echo -e "${GREEN}Starting build...${NC}"
echo ""

# Build the image
if docker build ${BUILD_ARGS} -t ${IMAGE_NAME}:${IMAGE_TAG} .; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo -e "${GREEN}========================================${NC}"

    # Display image information
    echo ""
    echo -e "${YELLOW}Image Details:${NC}"
    docker images ${IMAGE_NAME}:${IMAGE_TAG}

    # Display image size
    IMAGE_SIZE=$(docker images ${IMAGE_NAME}:${IMAGE_TAG} --format "{{.Size}}")
    echo ""
    echo -e "${GREEN}Image Size: ${IMAGE_SIZE}${NC}"

    # Ask to tag as latest if not already
    if [ "${IMAGE_TAG}" != "latest" ]; then
        echo ""
        read -p "Tag as 'latest' as well? (Y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
            echo -e "${GREEN}✓ Tagged as latest${NC}"
        fi
    fi

    # Display next steps
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}Next Steps:${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    echo "1. Run the container:"
    echo "   ./run.sh"
    echo ""
    echo "2. Or run with docker-compose:"
    echo "   cd ../.."
    echo "   docker-compose up auth-service"
    echo ""
    echo "3. Test the service:"
    echo "   curl http://localhost:3001/health"
    echo ""
else
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}✗ Build failed!${NC}"
    echo -e "${RED}========================================${NC}"
    exit 1
fi
