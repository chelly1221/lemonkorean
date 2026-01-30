#!/bin/bash

# ================================================================
# Docker Image Builder for Kubernetes
# ================================================================
# 모든 마이크로서비스의 Docker 이미지를 빌드합니다
# ================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
VERSION="${1:-latest}"
REGISTRY="${REGISTRY:-}"  # 자체 레지스트리 주소 (예: registry.example.com)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

build_service() {
    local service=$1
    local context=$2
    local image_name="${REGISTRY}lemon-korean/${service}:${VERSION}"

    log "Building $service..."

    if [ -f "$PROJECT_ROOT/$context/Dockerfile" ]; then
        docker build -t "$image_name" "$PROJECT_ROOT/$context"
        log "✓ Built: $image_name"

        # Tag as latest
        if [ "$VERSION" != "latest" ]; then
            docker tag "$image_name" "${REGISTRY}lemon-korean/${service}:latest"
        fi
    else
        error "Dockerfile not found: $PROJECT_ROOT/$context/Dockerfile"
    fi
}

main() {
    log "=== Building Lemon Korean Docker Images ==="
    log "Version: $VERSION"
    log "Registry: ${REGISTRY:-local}"
    echo ""

    cd "$PROJECT_ROOT"

    # Build all services
    build_service "auth-service" "services/auth"
    build_service "content-service" "services/content"
    build_service "progress-service" "services/progress"
    build_service "media-service" "services/media"
    build_service "analytics-service" "services/analytics"
    build_service "admin-service" "services/admin"

    echo ""
    log "=== Build Summary ==="
    docker images | grep "lemon-korean" | head -12

    echo ""
    log "✓ All images built successfully!"

    if [ -n "$REGISTRY" ]; then
        echo ""
        warn "To push images to registry, run:"
        echo "  docker push ${REGISTRY}lemon-korean/auth-service:${VERSION}"
        echo "  # ... repeat for all services"
        echo ""
        echo "Or use: ./kubernetes/scripts/push-images.sh ${VERSION}"
    fi
}

main "$@"
