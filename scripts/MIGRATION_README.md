# NAS to Local Disk Migration

## Overview

This migration moves MinIO data, Nginx cache/logs, Flutter web builds, and APK builds from NAS storage (`/mnt/nas/lemon/`) to local disk (`./data/`).

## What Changed

### Volume Mounts (docker-compose.yml)

| Service | Old Mount | New Mount |
|---------|-----------|-----------|
| MinIO | `/mnt/nas/lemon/minio-data:/data` | `./data/minio-data:/data` |
| Nginx (cache) | `/mnt/nas/lemon/nginx-cache:/var/cache/nginx` | `./data/nginx-cache:/var/cache/nginx` |
| Nginx (logs) | `/mnt/nas/lemon/nginx-logs:/var/log/nginx` | `./data/nginx-logs:/var/log/nginx` |
| Nginx (web) | `/mnt/nas/lemon/flutter-build/build/web` | `./data/flutter-build/web` |
| Admin | `/mnt/nas/lemon/apk-builds:/mnt/nas/lemon/apk-builds:ro` | `./data/apk-builds:/apk-builds:ro` |

### No Code Changes

- All services (Media, Admin, etc.) remain unchanged
- MinIO architecture stays the same
- API endpoints unchanged
- Only storage location changed

## Migration Steps

### 1. Backup (Optional)

```bash
sudo tar -czf /tmp/nas-backup-$(date +%Y%m%d).tar.gz /mnt/nas/lemon/
```

### 2. Run Migration Script

```bash
cd /home/sanchan/lemonkorean
sudo bash scripts/migrate-nas-to-local.sh
```

This will:
- Create `./data/` directory structure
- Copy MinIO data (~489KB)
- Copy Nginx cache/logs
- Copy APK builds
- Set correct permissions (uid 1000)

### 3. Stop Services

```bash
docker compose down
```

### 4. Verify docker-compose.yml

The volume mounts have already been updated. Review changes:

```bash
git diff docker-compose.yml
```

### 5. Start Services

```bash
docker compose up -d
```

### 6. Verify Services

```bash
# Check all containers running
docker compose ps

# Check MinIO health
docker exec lemon-minio mc ping local

# Verify MinIO data
docker exec lemon-minio mc ls local/lemon-korean-media

# Test image serving
curl -I https://lemon.3chan.kr/media/images/7257ea9ee6b0742a990c3d5bd2ca7cfc.png
```

## Rollback Plan

If migration fails:

```bash
# Stop services
docker compose down

# Restore original docker-compose.yml
git checkout docker-compose.yml

# Restart with NAS mounts
docker compose up -d
```

## Benefits

- ✅ No NAS dependency
- ✅ Simpler setup
- ✅ Faster I/O (local disk)
- ✅ Easier backup (`./data/`)
- ✅ No code changes

## Directory Structure

```
/home/sanchan/lemonkorean/data/
├── minio-data/         # MinIO S3 storage
├── nginx-cache/        # Nginx cache
├── nginx-logs/         # Nginx access/error logs
├── flutter-build/web/  # Flutter web app
└── apk-builds/         # APK builds
```

## Migration Date

**Executed**: 2026-02-07
**Status**: Pending execution
