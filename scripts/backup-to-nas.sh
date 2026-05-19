#!/bin/bash
set -euo pipefail

# Daily off-site backup of lemon (Lemon Korean) -> ASUSTOR NAS via rsync
# daemon, over Tailscale.
#
# Two databases (PostgreSQL + MongoDB) are dumped as timestamped archives,
# pruned to KEEP_LOCAL, and mirrored to the NAS with --delete so the
# off-site history stays bounded. The file trees (MinIO objects + APK
# builds) are mirrored incrementally to their own NAS folder.
#
# Cron (3chan crontab, 21:30 UTC daily):
#   30 21 * * * /srv/lemon/scripts/backup-to-nas.sh >> /home/3chan/lemon-backup.log 2>&1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

KEEP_LOCAL="${KEEP_LOCAL:-14}"
NAS_DEST="${NAS_DEST:-rsync://3chan@100.75.89.101/hetzner}"
RSYNC_PASSWORD_FILE="${RSYNC_PASSWORD_FILE:-${PROJECT_DIR}/.rsync-pass}"

TS="$(date +%Y%m%d-%H%M%S)"
echo "[lemon-backup] $(date -Is) starting"
mkdir -p "${PROJECT_DIR}/backups"

# 1. PostgreSQL dump — consistent, gzipped, timestamped.
PG="${PROJECT_DIR}/backups/lemon-pg-${TS}.sql.gz"
docker exec lemon-postgres sh -c \
  'exec pg_dump -U 3chan -d lemon_korean --clean --if-exists' \
  | gzip > "${PG}"
echo "[lemon-backup] postgres dumped ($(du -h "${PG}" | cut -f1))"

# 2. MongoDB dump — gzipped archive, timestamped.
MG="${PROJECT_DIR}/backups/lemon-mongo-${TS}.archive.gz"
docker exec lemon-mongo sh -c \
  'exec mongodump --username 3chan --password "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin --db lemon_korean --archive --gzip' \
  > "${MG}"
echo "[lemon-backup] mongo dumped ($(du -h "${MG}" | cut -f1))"

# 3. Prune local dumps, keeping the most recent KEEP_LOCAL of each.
ls -t "${PROJECT_DIR}/backups"/lemon-pg-*.sql.gz \
  | tail -n +"$((KEEP_LOCAL + 1))" | xargs -r rm -v
ls -t "${PROJECT_DIR}/backups"/lemon-mongo-*.archive.gz \
  | tail -n +"$((KEEP_LOCAL + 1))" | xargs -r rm -v

# 4. Mirror the kept DB dumps to the NAS subfolder (--delete keeps it bounded).
rsync -a --delete --partial --password-file="${RSYNC_PASSWORD_FILE}" \
  --include='lemon-pg-*.sql.gz' --include='lemon-mongo-*.archive.gz' --exclude='*' \
  "${PROJECT_DIR}/backups/" "${NAS_DEST}/lemon/"
echo "[lemon-backup] db dumps mirrored to ${NAS_DEST}/lemon/ (keeping ${KEEP_LOCAL})"

# 5. Mirror the file trees (MinIO objects + APK builds) to their own NAS
#    folder. rsync exit 24 ("some files vanished") is a warning, not error.
rc=0
rsync -a --delete --partial --password-file="${RSYNC_PASSWORD_FILE}" \
  --exclude='minio-data/.minio.sys/tmp/' \
  "${PROJECT_DIR}/data/minio-data" \
  "${PROJECT_DIR}/data/apk-builds" \
  "${NAS_DEST}/lemon-files/" || rc=$?
if [ "${rc}" -ne 0 ] && [ "${rc}" -ne 24 ]; then
  echo "[lemon-backup] rsync failed (code ${rc})" >&2
  exit "${rc}"
fi
echo "[lemon-backup] files mirrored to ${NAS_DEST}/lemon-files/ (rsync rc=${rc})"

echo "[lemon-backup] $(date -Is) done"
