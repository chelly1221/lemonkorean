#!/bin/bash

# ================================================================
# Kubernetes Deployment Script
# ================================================================
# Lemon Korean 애플리케이션을 Kubernetes에 배포합니다
# ================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
ENVIRONMENT="${1:-prod}"
NAMESPACE="lemon-korean"
KUBE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

section() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
    echo ""
}

check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        error "kubectl not found. Please install kubectl first."
    fi

    if ! kubectl cluster-info &> /dev/null; then
        error "Cannot connect to Kubernetes cluster. Check your kubeconfig."
    fi

    log "Connected to Kubernetes cluster"
}

check_kustomize() {
    if ! command -v kustomize &> /dev/null; then
        warn "kustomize not found. Using kubectl apply -k instead."
    fi
}

create_namespace() {
    section "Creating Namespace"

    if kubectl get namespace "$NAMESPACE" &> /dev/null; then
        log "Namespace $NAMESPACE already exists"
    else
        kubectl create namespace "$NAMESPACE"
        log "✓ Namespace $NAMESPACE created"
    fi
}

create_secrets() {
    section "Creating Secrets"

    warn "Please ensure secrets are created manually for security:"
    echo ""
    echo "kubectl create secret generic lemon-korean-secrets \\"
    echo "  --from-literal=DB_PASSWORD=your_password \\"
    echo "  --from-literal=REDIS_PASSWORD=your_password \\"
    echo "  --from-literal=RABBITMQ_PASSWORD=your_password \\"
    echo "  --from-literal=MINIO_ACCESS_KEY=your_key \\"
    echo "  --from-literal=MINIO_SECRET_KEY=your_secret \\"
    echo "  --from-literal=JWT_SECRET=your_jwt_secret \\"
    echo "  -n $NAMESPACE"
    echo ""

    read -p "Have you created the secrets? (yes/no): " secrets_created

    if [ "$secrets_created" != "yes" ]; then
        error "Please create secrets first before deploying."
    fi
}

deploy_infrastructure() {
    section "Deploying Infrastructure Services"

    log "Deploying PostgreSQL..."
    kubectl apply -f "$KUBE_DIR/base/postgres-statefulset.yaml"

    log "Deploying MongoDB..."
    kubectl apply -f "$KUBE_DIR/base/mongodb-statefulset.yaml"

    log "Deploying Redis..."
    kubectl apply -f "$KUBE_DIR/base/redis-deployment.yaml"

    log "Deploying MinIO..."
    kubectl apply -f "$KUBE_DIR/base/minio-statefulset.yaml"

    log "Deploying RabbitMQ..."
    kubectl apply -f "$KUBE_DIR/base/rabbitmq-deployment.yaml"

    log "Waiting for infrastructure to be ready..."
    sleep 10

    kubectl wait --for=condition=ready pod \
        -l app=postgres \
        -n "$NAMESPACE" \
        --timeout=300s || warn "PostgreSQL not ready yet"

    kubectl wait --for=condition=ready pod \
        -l app=redis \
        -n "$NAMESPACE" \
        --timeout=300s || warn "Redis not ready yet"

    log "✓ Infrastructure services deployed"
}

deploy_microservices() {
    section "Deploying Microservices"

    log "Deploying Auth Service..."
    kubectl apply -f "$KUBE_DIR/base/auth-service-deployment.yaml"

    log "Deploying Content Service..."
    kubectl apply -f "$KUBE_DIR/base/content-service-deployment.yaml"

    log "Deploying Progress Service..."
    kubectl apply -f "$KUBE_DIR/base/progress-service-deployment.yaml"

    log "Deploying Media Service..."
    kubectl apply -f "$KUBE_DIR/base/media-service-deployment.yaml"

    log "Deploying Analytics Service..."
    kubectl apply -f "$KUBE_DIR/base/analytics-service-deployment.yaml"

    log "Deploying Admin Service..."
    kubectl apply -f "$KUBE_DIR/base/admin-service-deployment.yaml"

    log "Waiting for services to be ready..."
    sleep 15

    kubectl wait --for=condition=available deployment \
        -l app=auth-service \
        -n "$NAMESPACE" \
        --timeout=300s || warn "Auth Service not ready yet"

    log "✓ Microservices deployed"
}

deploy_gateway() {
    section "Deploying API Gateway"

    log "Deploying Nginx Gateway..."
    kubectl apply -f "$KUBE_DIR/base/nginx-ingress.yaml"

    log "✓ API Gateway deployed"
}

show_status() {
    section "Deployment Status"

    log "Pods:"
    kubectl get pods -n "$NAMESPACE"

    echo ""
    log "Services:"
    kubectl get services -n "$NAMESPACE"

    echo ""
    log "Access the application:"
    echo "  HTTP: http://<node-ip>:30080"
    echo "  HTTPS: https://<node-ip>:30443"
    echo ""
    echo "Get node IP:"
    echo "  kubectl get nodes -o wide"
}

main() {
    log "=== Deploying Lemon Korean to Kubernetes ==="
    log "Environment: $ENVIRONMENT"
    log "Namespace: $NAMESPACE"

    check_kubectl
    check_kustomize

    create_namespace
    create_secrets

    deploy_infrastructure
    deploy_microservices
    deploy_gateway

    show_status

    echo ""
    log "✓ Deployment complete!"
    log "Monitor pods: kubectl get pods -n $NAMESPACE -w"
    log "View logs: kubectl logs -f <pod-name> -n $NAMESPACE"
}

main "$@"
