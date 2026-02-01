# Docker Volume Persistence Audit Report
**Date**: 2026-02-01
**Project**: Lemon Korean Learning Platform

## Executive Summary

Audit of all Docker containers to ensure critical data persists through volume mounts. Overall status: **GOOD** with minor recommendations for improvement.

---

## ✅ Properly Persisted Data (10 Named Volumes)

### Database & Storage Services
| Service | Volume | Mount Point | Data Type | Status |
|---------|--------|-------------|-----------|--------|
| **PostgreSQL** | `postgres-data` | `/var/lib/postgresql/data` | Relational database | ✅ CRITICAL |
| **MongoDB** | `mongo-data` | `/data/db` | Document database | ✅ CRITICAL |
| **Redis** | `redis-data` | `/data` | Cache & sessions | ✅ IMPORTANT |
| **MinIO** | `minio-data` | `/data` | Media files (S3) | ✅ CRITICAL |
| **RabbitMQ** | `rabbitmq-data` | `/var/lib/rabbitmq` | Message queue | ✅ IMPORTANT |

### Management & Monitoring Tools
| Service | Volume | Mount Point | Data Type | Status |
|---------|--------|-------------|-----------|--------|
| **pgAdmin** | `pgadmin-data` | `/var/lib/pgadmin` | DB admin settings | ✅ OPTIONAL |
| **Nginx Proxy Manager** | `nginx-proxy-manager-data` | `/data` | Proxy config | ✅ IMPORTANT |
| **Nginx Proxy Manager** | `nginx-proxy-manager-letsencrypt` | `/etc/letsencrypt` | SSL certificates | ✅ IMPORTANT |
| **Prometheus** | `prometheus-data` | `/prometheus` | Metrics (30d retention) | ✅ IMPORTANT |
| **Grafana** | `grafana-data` | `/var/lib/grafana` | Dashboards | ✅ IMPORTANT |

**Total Named Volumes**: 10 (dev) + 5 (prod) = 15 volumes

---

## ⚠️ Areas for Improvement

### 1. Nginx Logs (Bind Mount)
**Current Setup**:
```yaml
volumes:
  - ./nginx/logs:/var/log/nginx
```

**Status**: Acceptable but not ideal
**Size**: 2.0 MB (growing)
**Risk**: Low (logs can be recreated, but history is lost)

**Recommendation**:
```yaml
# Option A: Use named volume (preferred)
volumes:
  - nginx-logs:/var/log/nginx

volumes:
  nginx-logs:
    name: lemon-nginx-logs

# Option B: Add log rotation
# Create: /etc/logrotate.d/lemon-nginx
/home/sanchan/lemonkorean/nginx/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
}
```

### 2. Nginx Cache (Bind Mount)
**Current Setup**:
```yaml
volumes:
  - ./nginx/cache:/var/cache/nginx
```

**Status**: Acceptable (cache is ephemeral)
**Size**: 32 KB
**Risk**: Very Low (cache can be regenerated)

**Recommendation**: Consider named volume for cleaner isolation
```yaml
volumes:
  - nginx-cache:/var/cache/nginx

volumes:
  nginx-cache:
    name: lemon-nginx-cache
```

### 3. SSL Certificates (Production Only)
**Current Setup** (docker-compose.prod.yml):
```yaml
volumes:
  - ./nginx/ssl:/etc/nginx/ssl:ro
```

**Status**: Functional but manual
**Risk**: Medium (manual cert renewal required)

**Recommendation**: Use Let's Encrypt automation
```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx

# Obtain certificate
sudo certbot --nginx -d lemon.3chan.kr -d www.lemon.3chan.kr

# Auto-renewal is handled by systemd timer
systemctl status certbot.timer
```

---

## ✅ Stateless Services (No Volumes Needed)

These services store data in databases and don't need local persistence:

| Service | Language | Storage Location | Notes |
|---------|----------|------------------|-------|
| **auth-service** | Node.js | PostgreSQL + Redis | JWT tokens in Redis |
| **content-service** | Node.js | PostgreSQL + MongoDB | Lesson content |
| **progress-service** | Go | PostgreSQL + Redis | User progress |
| **media-service** | Go | MinIO + Redis | Media files in MinIO |
| **analytics-service** | Python | PostgreSQL + MongoDB | Event logs |
| **admin-service** | Node.js | All databases | Management UI |

**Dev-only bind mounts** (hot reload):
- `./services/auth/src:/app/src`
- `./services/content/src:/app/src`
- `./services/admin/src:/app/src`
- `./services/admin/public:/app/public`
- `./services/analytics:/app`

These are **intentionally NOT persisted** in production builds (code is baked into Docker images).

---

## ✅ Special Mount Points

### Admin Service Special Mounts
```yaml
volumes:
  - ./.env:/app/.env                    # Environment variables
  - /var/run/docker.sock:/var/run/docker.sock  # Docker API access
  - ./:/project:ro                      # Project docs (read-only)
```

**Purpose**: Admin dashboard needs Docker API access to show container status and read dev-notes.

**Security**: Docker socket access is risky in production. Consider using Docker API with TLS.

### Flutter Web App
```yaml
volumes:
  - ./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro
```

**Status**: ✅ Read-only static files (no persistence needed)
**Note**: Rebuild required when updating web app

---

## 📊 Volume Size Analysis

```bash
# Check current volume sizes
docker system df -v | grep lemon

# Example output (estimated):
lemon-postgres-data          ~500MB   (database)
lemon-mongo-data             ~200MB   (lesson content)
lemon-redis-data             ~50MB    (cache)
lemon-minio-data             ~2GB     (media files)
lemon-rabbitmq-data          ~10MB    (message queue)
lemon-prometheus-data        ~1GB     (30d metrics)
lemon-grafana-data           ~100MB   (dashboards)
pgadmin-data                 ~50MB    (settings)
nginx-proxy-manager-data     ~20MB    (config)
```

**Total Estimated**: ~4-5 GB

---

## 🔒 Backup Strategy

All critical volumes should be backed up regularly. See `/scripts/backup/` for automation:

```bash
# Automated backups (already implemented)
./scripts/backup/backup-all.sh          # Full backup
./scripts/backup/backup-postgres.sh     # PostgreSQL only
./scripts/backup/backup-mongodb.sh      # MongoDB only

# Setup cron (already configured)
./scripts/backup/setup-cron.sh
```

**Backup Schedule**:
- **Daily**: PostgreSQL + MongoDB (3:00 AM)
- **Weekly**: Full system backup (Sunday 4:00 AM)
- **Monthly**: Long-term archive (1st day of month)

---

## 🚀 Recommended Actions

### Priority: HIGH
1. ✅ **Database volumes are properly configured** - No action needed
2. ✅ **Backup system is in place** - No action needed
3. ⚠️ **SSL certificate automation** - Consider Let's Encrypt (production)

### Priority: MEDIUM
4. ⚠️ **Nginx logs rotation** - Implement logrotate to prevent unbounded growth
5. ⚠️ **Docker socket security** - Review admin-service access in production

### Priority: LOW
6. ⚠️ **Nginx cache named volume** - Use named volume instead of bind mount
7. ⚠️ **Nginx logs named volume** - Use named volume instead of bind mount

---

## 📝 Implementation Steps

### Step 1: Add Nginx Log Rotation
```bash
# Create logrotate config
sudo nano /etc/logrotate.d/lemon-nginx

# Add configuration:
/home/sanchan/lemonkorean/nginx/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    missingok
    create 0640 sanchan sanchan
    sharedscripts
    postrotate
        docker exec lemon-nginx nginx -s reload 2>/dev/null || true
    endscript
}

# Test
sudo logrotate -d /etc/logrotate.d/lemon-nginx
```

### Step 2: Migrate Nginx Logs to Named Volume (Optional)
```bash
# 1. Stop nginx
docker compose stop nginx

# 2. Copy existing logs
mkdir -p /tmp/nginx-logs-backup
cp -r nginx/logs/* /tmp/nginx-logs-backup/

# 3. Update docker-compose.yml
# Replace: ./nginx/logs:/var/log/nginx
# With: nginx-logs:/var/log/nginx

# 4. Add to volumes section:
# nginx-logs:
#   name: lemon-nginx-logs

# 5. Restart nginx
docker compose up -d nginx

# 6. Restore logs (if needed)
docker cp /tmp/nginx-logs-backup/. lemon-nginx:/var/log/nginx/
```

### Step 3: SSL Certificate Automation (Production)
```bash
# 1. Install certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# 2. Stop nginx container (to free port 80)
docker compose stop nginx

# 3. Obtain certificate
sudo certbot certonly --standalone -d lemon.3chan.kr -d www.lemon.3chan.kr

# 4. Copy certs to nginx/ssl/
sudo cp /etc/letsencrypt/live/lemon.3chan.kr/fullchain.pem nginx/ssl/
sudo cp /etc/letsencrypt/live/lemon.3chan.kr/privkey.pem nginx/ssl/
sudo chmod 644 nginx/ssl/*.pem

# 5. Restart nginx
docker compose up -d nginx

# 6. Setup auto-renewal
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

# 7. Add renewal hook
sudo nano /etc/letsencrypt/renewal-hooks/deploy/docker-nginx.sh

#!/bin/bash
cp /etc/letsencrypt/live/lemon.3chan.kr/fullchain.pem /home/sanchan/lemonkorean/nginx/ssl/
cp /etc/letsencrypt/live/lemon.3chan.kr/privkey.pem /home/sanchan/lemonkorean/nginx/ssl/
chmod 644 /home/sanchan/lemonkorean/nginx/ssl/*.pem
docker compose -f /home/sanchan/lemonkorean/docker-compose.yml restart nginx

# Make executable
sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/docker-nginx.sh
```

---

## ✅ Conclusion

**Overall Assessment**: GOOD

Your Docker volume configuration properly persists all critical data:
- ✅ All databases have named volumes
- ✅ Media storage is persisted
- ✅ SSL certificates are managed
- ✅ Monitoring data is retained
- ✅ Backup system is in place

**Minor Improvements Recommended**:
- Implement log rotation for nginx logs
- Consider SSL automation with Let's Encrypt
- Optionally migrate bind mounts to named volumes

**No Critical Issues Found** - Your infrastructure is production-ready from a data persistence perspective.

---

## 📚 References

- Docker Compose File: `/home/sanchan/lemonkorean/docker-compose.yml`
- Production Config: `/home/sanchan/lemonkorean/docker-compose.prod.yml`
- Monitoring Config: `/home/sanchan/lemonkorean/docker-compose.monitoring.yml`
- Backup Scripts: `/home/sanchan/lemonkorean/scripts/backup/`
- Volume Documentation: https://docs.docker.com/storage/volumes/
