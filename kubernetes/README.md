# Kubernetes Deployment Guide

자체 서버에서 Lemon Korean을 Kubernetes로 배포하는 가이드입니다.

## 📋 목차

1. [Prerequisites](#prerequisites)
2. [Kubernetes 설치](#kubernetes-설치)
3. [Docker 이미지 빌드](#docker-이미지-빌드)
4. [배포 프로세스](#배포-프로세스)
5. [설정 및 관리](#설정-및-관리)
6. [트러블슈팅](#트러블슈팅)

---

## Prerequisites

### 필수 도구
```bash
# kubectl 설치
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# kustomize 설치 (선택 사항)
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/

# Docker 설치 (이미지 빌드용)
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
```

### 시스템 요구사항
- **최소**: CPU 4코어, RAM 8GB, 디스크 50GB
- **권장**: CPU 8코어, RAM 16GB, 디스크 100GB
- **OS**: Ubuntu 20.04+ 또는 다른 Linux 배포판
- **네트워크**: 고정 IP 주소 권장

---

## Kubernetes 설치

### 옵션 1: k3s (경량, 추천)

k3s는 자체 서버에 최적화된 경량 Kubernetes입니다.

```bash
# k3s 설치
curl -sfL https://get.k3s.io | sh -

# kubeconfig 설정
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

# 설치 확인
kubectl get nodes
kubectl get pods -A
```

### 옵션 2: microk8s

```bash
# microk8s 설치
sudo snap install microk8s --classic

# 사용자 그룹 추가
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube

# 재로그인 후
microk8s enable dns storage
microk8s kubectl get nodes

# kubectl alias
alias kubectl='microk8s kubectl'
```

### 옵션 3: 완전한 Kubernetes (kubeadm)

```bash
# kubeadm, kubelet, kubectl 설치
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 클러스터 초기화
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# kubeconfig 설정
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# CNI 설치 (Flannel)
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

---

## Docker 이미지 빌드

### 1. 모든 서비스 이미지 빌드

```bash
# 프로젝트 루트에서
cd /home/sanchan/lemonkorean

# 모든 이미지 빌드 (버전 태그 지정)
chmod +x kubernetes/scripts/build-images.sh
./kubernetes/scripts/build-images.sh v1.0.0

# 또는 latest 태그로 빌드
./kubernetes/scripts/build-images.sh latest
```

### 2. 개별 서비스 빌드

```bash
# Auth Service
docker build -t lemon-korean/auth-service:v1.0.0 ./services/auth

# Content Service
docker build -t lemon-korean/content-service:v1.0.0 ./services/content

# Progress Service
docker build -t lemon-korean/progress-service:v1.0.0 ./services/progress

# Media Service
docker build -t lemon-korean/media-service:v1.0.0 ./services/media

# Analytics Service
docker build -t lemon-korean/analytics-service:v1.0.0 ./services/analytics

# Admin Service
docker build -t lemon-korean/admin-service:v1.0.0 ./services/admin
```

### 3. 이미지 확인

```bash
docker images | grep lemon-korean
```

### 4. k3s에서 이미지 import (k3s 사용 시)

```bash
# k3s는 로컬 Docker 이미지를 자동으로 인식하지 못하므로 import 필요
sudo k3s ctr images import <image>.tar

# 또는 Docker 레지스트리 없이 직접 사용
# k3s containerd에 이미지 로드
for service in auth content progress media analytics admin; do
    docker save lemon-korean/${service}-service:v1.0.0 | \
        sudo k3s ctr images import -
done
```

---

## 배포 프로세스

### 1. Secrets 생성

**중요**: 실제 프로덕션 환경에서는 절대 secrets.yaml을 git에 커밋하지 마세요!

```bash
# Secrets 생성
kubectl create secret generic lemon-korean-secrets \
  --from-literal=DB_PASSWORD='your_secure_postgres_password' \
  --from-literal=REDIS_PASSWORD='your_secure_redis_password' \
  --from-literal=RABBITMQ_PASSWORD='your_secure_rabbitmq_password' \
  --from-literal=MINIO_ACCESS_KEY='your_minio_access_key' \
  --from-literal=MINIO_SECRET_KEY='your_minio_secret_key' \
  --from-literal=JWT_SECRET='your_very_long_random_jwt_secret_key' \
  --from-literal=JWT_EXPIRES_IN='7d' \
  --from-literal=ADMIN_EMAILS='admin@lemonkorean.com' \
  --from-literal=GRAFANA_ADMIN_PASSWORD='your_grafana_password' \
  -n lemon-korean --dry-run=client -o yaml | kubectl apply -f -
```

### 2. 자동 배포 (권장)

```bash
# 배포 스크립트 실행
chmod +x kubernetes/scripts/deploy.sh
./kubernetes/scripts/deploy.sh prod
```

### 3. 수동 배포

```bash
# Namespace 생성
kubectl apply -f kubernetes/base/namespace.yaml

# ConfigMap 생성
kubectl apply -f kubernetes/base/configmap.yaml

# 인프라 서비스 배포
kubectl apply -f kubernetes/base/postgres-statefulset.yaml
kubectl apply -f kubernetes/base/mongodb-statefulset.yaml
kubectl apply -f kubernetes/base/redis-deployment.yaml
kubectl apply -f kubernetes/base/minio-statefulset.yaml
kubectl apply -f kubernetes/base/rabbitmq-deployment.yaml

# 인프라 준비 대기 (30초 ~ 2분)
kubectl wait --for=condition=ready pod -l app=postgres -n lemon-korean --timeout=300s

# 마이크로서비스 배포
kubectl apply -f kubernetes/base/auth-service-deployment.yaml
kubectl apply -f kubernetes/base/content-service-deployment.yaml
kubectl apply -f kubernetes/base/progress-service-deployment.yaml
kubectl apply -f kubernetes/base/media-service-deployment.yaml
kubectl apply -f kubernetes/base/analytics-service-deployment.yaml
kubectl apply -f kubernetes/base/admin-service-deployment.yaml

# API Gateway 배포
kubectl apply -f kubernetes/base/nginx-ingress.yaml
```

### 4. 배포 상태 확인

```bash
# 모든 리소스 확인
kubectl get all -n lemon-korean

# Pod 상태 모니터링
kubectl get pods -n lemon-korean -w

# 특정 Pod 로그 확인
kubectl logs -f <pod-name> -n lemon-korean

# 서비스 엔드포인트 확인
kubectl get svc -n lemon-korean
```

---

## 설정 및 관리

### 애플리케이션 접근

#### NodePort 사용 (기본)

```bash
# Node IP 확인
kubectl get nodes -o wide

# 서비스 포트 확인
kubectl get svc nginx-gateway -n lemon-korean

# 접근 URL
# HTTP: http://<node-ip>:30080
# HTTPS: https://<node-ip>:30443
```

#### Port Forward 사용 (로컬 테스트)

```bash
# Nginx Gateway로 포트 포워딩
kubectl port-forward -n lemon-korean svc/nginx-gateway 8080:80

# 로컬에서 접근
curl http://localhost:8080/health
```

### Persistent Volume 설정

k3s는 기본적으로 local-path provisioner를 제공합니다. 다른 Kubernetes를 사용하는 경우:

```yaml
# local-storage-class.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer

---
# PersistentVolume 예시
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /mnt/data/postgres
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - <your-node-name>
```

### 스케일링

```bash
# 특정 서비스 스케일 조정
kubectl scale deployment auth-service --replicas=3 -n lemon-korean
kubectl scale deployment content-service --replicas=3 -n lemon-korean

# HPA (Horizontal Pod Autoscaler) 설정
kubectl autoscale deployment auth-service \
    --cpu-percent=70 \
    --min=2 \
    --max=10 \
    -n lemon-korean
```

### 업데이트 및 롤백

```bash
# 새 이미지로 업데이트
kubectl set image deployment/auth-service \
    auth-service=lemon-korean/auth-service:v1.1.0 \
    -n lemon-korean

# 롤링 업데이트 상태 확인
kubectl rollout status deployment/auth-service -n lemon-korean

# 롤백
kubectl rollout undo deployment/auth-service -n lemon-korean

# 특정 리비전으로 롤백
kubectl rollout history deployment/auth-service -n lemon-korean
kubectl rollout undo deployment/auth-service --to-revision=2 -n lemon-korean
```

---

## 트러블슈팅

### Pod이 Pending 상태

```bash
# 상세 정보 확인
kubectl describe pod <pod-name> -n lemon-korean

# 일반적인 원인:
# 1. 리소스 부족
kubectl top nodes

# 2. PersistentVolume 미바인딩
kubectl get pv
kubectl get pvc -n lemon-korean
```

### Pod이 CrashLoopBackOff

```bash
# 로그 확인
kubectl logs <pod-name> -n lemon-korean
kubectl logs <pod-name> -n lemon-korean --previous

# 일반적인 원인:
# 1. 환경 변수 오류 (Secrets/ConfigMap)
# 2. 데이터베이스 연결 실패
# 3. 포트 충돌
```

### 서비스 연결 실패

```bash
# DNS 테스트
kubectl run -it --rm debug --image=busybox --restart=Never -n lemon-korean -- sh
# 컨테이너 안에서:
nslookup postgres-service
nslookup auth-service

# 서비스 엔드포인트 확인
kubectl get endpoints -n lemon-korean
```

### 이미지 Pull 실패

```bash
# ImagePullBackOff 에러
# k3s containerd에 이미지 import
docker save lemon-korean/auth-service:v1.0.0 | sudo k3s ctr images import -

# 또는 imagePullPolicy 변경
# deployment yaml에서: imagePullPolicy: Never (로컬 이미지만 사용)
```

### 데이터베이스 초기화 실패

```bash
# PostgreSQL Pod에 접속
kubectl exec -it postgres-0 -n lemon-korean -- psql -U lemon_admin -d lemon_korean

# 수동 스키마 적용
kubectl cp database/postgres/init/01_schema.sql lemon-korean/postgres-0:/tmp/
kubectl exec -it postgres-0 -n lemon-korean -- \
    psql -U lemon_admin -d lemon_korean -f /tmp/01_schema.sql
```

### Persistent Volume 문제

```bash
# PV 상태 확인
kubectl get pv

# PVC 바인딩 확인
kubectl get pvc -n lemon-korean

# 수동 PV 생성 (local-path 사용 안 할 경우)
# 위의 "Persistent Volume 설정" 섹션 참고
```

---

## 유용한 명령어

```bash
# 전체 리소스 확인
kubectl get all -n lemon-korean

# 특정 타입 리소스
kubectl get pods,svc,deploy,sts -n lemon-korean

# 리소스 사용량
kubectl top pods -n lemon-korean
kubectl top nodes

# 이벤트 확인
kubectl get events -n lemon-korean --sort-by='.lastTimestamp'

# 모든 Pod 로그 스트리밍
stern -n lemon-korean .

# 설정 확인
kubectl get configmap lemon-korean-config -n lemon-korean -o yaml
kubectl get secret lemon-korean-secrets -n lemon-korean -o yaml

# 전체 삭제
kubectl delete namespace lemon-korean
```

---

## 백업 및 복구

### 백업

```bash
# PostgreSQL 백업
kubectl exec -it postgres-0 -n lemon-korean -- \
    pg_dump -U lemon_admin lemon_korean | gzip > backup-$(date +%Y%m%d).sql.gz

# MongoDB 백업
kubectl exec -it mongodb-0 -n lemon-korean -- \
    mongodump --username=lemon_admin --password=<password> --authenticationDatabase=admin \
    --out=/tmp/backup
kubectl cp lemon-korean/mongodb-0:/tmp/backup ./mongodb-backup-$(date +%Y%m%d)

# PersistentVolume 백업 (호스트에서)
sudo tar czf /backups/k8s-pv-$(date +%Y%m%d).tar.gz /var/lib/rancher/k3s/storage/
```

### 복구

```bash
# PostgreSQL 복구
gunzip < backup-20260128.sql.gz | kubectl exec -i postgres-0 -n lemon-korean -- \
    psql -U lemon_admin lemon_korean

# MongoDB 복구
kubectl cp ./mongodb-backup-20260128 lemon-korean/mongodb-0:/tmp/restore
kubectl exec -it mongodb-0 -n lemon-korean -- \
    mongorestore --username=lemon_admin --password=<password> \
    --authenticationDatabase=admin /tmp/restore
```

---

## 성능 튜닝

### 리소스 할당 최적화

```yaml
# 프로덕션 권장 설정
resources:
  requests:
    memory: "256Mi"
    cpu: "200m"
  limits:
    memory: "1Gi"
    cpu: "1000m"
```

### 네트워크 최적화

```bash
# CoreDNS 캐시 늘리기
kubectl edit configmap coredns -n kube-system
# cache 30 → cache 300

# NodePort 성능 향상 (k3s)
# /etc/rancher/k3s/config.yaml 추가:
# kube-apiserver-arg:
#   - "service-node-port-range=80-32767"
```

---

## 다음 단계

1. **SSL/TLS 설정**: cert-manager로 자동 SSL 인증서 발급
2. **모니터링**: Prometheus + Grafana 통합
3. **로깅**: EFK (Elasticsearch + Fluentd + Kibana) 스택
4. **CI/CD**: GitOps (ArgoCD 또는 Flux)

---

**작성일**: 2026-01-28
**버전**: 1.0.0
**유지보수**: Lemon Korean DevOps Team
