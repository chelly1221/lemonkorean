#!/bin/bash
# Lemon Korean - Data Loss Prevention Setup
# 데이터 손실 방지 안전장치 설정

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🛡️  Lemon Korean - Data Loss Prevention Setup"
echo "================================================"
echo ""

cd "$PROJECT_ROOT"

# 1. Bash alias 추가
echo "📝 Step 1: Adding safety aliases to shell config..."

# Detect shell config file
if [ -n "$ZSH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.bashrc"
else
  SHELL_CONFIG="$HOME/.bashrc"  # Default
fi

if ! grep -q "Lemon Korean Docker Safety Aliases" "$SHELL_CONFIG" 2>/dev/null; then
  cat >> "$SHELL_CONFIG" << 'EOF'

# === Lemon Korean Docker Safety Aliases ===
# Prevent accidental data loss from docker-compose down -v

alias docker-compose-down='echo "⚠️  WARNING: This command is blocked for safety."; echo "Use: docker-compose-down-safe (preserves volumes)"; echo "Or: docker-compose-down-volumes (deletes volumes - DANGEROUS!)"; false'

alias docker-compose-down-safe='docker compose down'

alias docker-compose-down-volumes='echo "⚠️  DANGER: This will DELETE ALL VOLUMES!"; echo -n "Type YES (all caps) to confirm: "; read confirm; if [ "$confirm" = "YES" ]; then docker compose down -v; else echo "Cancelled."; fi'

alias docker-system-prune='echo "⚠️  WARNING: This command is blocked for safety."; echo "Use: docker-system-prune-safe (preserves volumes)"; false'

alias docker-system-prune-safe='docker system prune'

alias docker-system-prune-all='echo "⚠️  DANGER: This will DELETE UNUSED VOLUMES!"; echo -n "Type YES (all caps) to confirm: "; read confirm; if [ "$confirm" = "YES" ]; then docker system prune -a --volumes; else echo "Cancelled."; fi'

# End of Lemon Korean Docker Safety Aliases
EOF
  echo "✅ Safety aliases added to $SHELL_CONFIG"
else
  echo "ℹ️  Safety aliases already exist in $SHELL_CONFIG"
fi

# 2. 백업 스크립트 실행 권한
echo ""
echo "🔧 Step 2: Making backup scripts executable..."

if [ -d "$PROJECT_ROOT/scripts/backup" ]; then
  chmod +x "$PROJECT_ROOT/scripts/backup"/*.sh 2>/dev/null || true
  echo "✅ Backup scripts are now executable"
else
  echo "⚠️  Backup scripts directory not found at: $PROJECT_ROOT/scripts/backup"
fi

if [ -d "$PROJECT_ROOT/scripts/monitoring" ]; then
  chmod +x "$PROJECT_ROOT/scripts/monitoring"/*.sh 2>/dev/null || true
  echo "✅ Monitoring scripts are now executable"
fi

if [ -d "$PROJECT_ROOT/scripts/optimization" ]; then
  chmod +x "$PROJECT_ROOT/scripts/optimization"/*.sh 2>/dev/null || true
  echo "✅ Optimization scripts are now executable"
fi

# 3. 백업 디렉토리 생성
echo ""
echo "📁 Step 3: Creating backup directories..."

mkdir -p "$PROJECT_ROOT/backups/postgres/daily"
mkdir -p "$PROJECT_ROOT/backups/postgres/weekly"
mkdir -p "$PROJECT_ROOT/backups/postgres/monthly"
mkdir -p "$PROJECT_ROOT/backups/mongodb/daily"
mkdir -p "$PROJECT_ROOT/backups/mongodb/weekly"
mkdir -p "$PROJECT_ROOT/backups/mongodb/monthly"

echo "✅ Backup directories created"

# 4. 첫 백업 실행
echo ""
echo "💾 Step 4: Running initial backup..."

if [ -f "$PROJECT_ROOT/scripts/backup/backup-all.sh" ]; then
  if "$PROJECT_ROOT/scripts/backup/backup-all.sh"; then
    echo "✅ Initial backup completed successfully"
  else
    echo "⚠️  Backup script failed. Please check manually."
  fi
else
  echo "⚠️  Backup script not found. Skipping initial backup."
fi

# 5. 볼륨 모니터링 스크립트 생성
echo ""
echo "🔍 Step 5: Creating volume monitoring script..."

mkdir -p "$PROJECT_ROOT/scripts/monitoring"

cat > "$PROJECT_ROOT/scripts/monitoring/check-volumes.sh" << 'EOF'
#!/bin/bash
# Check critical Docker volumes exist

set -e

REQUIRED_VOLUMES=(
  "lemon-postgres-data"
  "lemon-mongo-data"
  "lemon-redis-data"
  "lemon-minio-data"
)

MISSING_VOLUMES=0

for volume in "${REQUIRED_VOLUMES[@]}"; do
  if ! docker volume inspect "$volume" &>/dev/null; then
    echo "❌ CRITICAL: Volume $volume does not exist!"
    MISSING_VOLUMES=$((MISSING_VOLUMES + 1))
  else
    echo "✅ Volume $volume exists"
  fi
done

if [ $MISSING_VOLUMES -gt 0 ]; then
  echo ""
  echo "❌ ERROR: $MISSING_VOLUMES critical volume(s) missing!"
  exit 1
fi

echo ""
echo "✅ All critical volumes exist"
EOF

chmod +x "$PROJECT_ROOT/scripts/monitoring/check-volumes.sh"
echo "✅ Volume monitoring script created"

# 6. 데이터 무결성 체크 스크립트 생성
echo ""
echo "🔍 Step 6: Creating data integrity check script..."

cat > "$PROJECT_ROOT/scripts/monitoring/check-data-integrity.sh" << 'EOF'
#!/bin/bash
# Check database data integrity

set -e

cd "$(dirname "$0")/../.."

# Check if containers are running
if ! docker compose ps postgres | grep -q "Up"; then
  echo "❌ PostgreSQL container is not running"
  exit 1
fi

# Check lesson count
LESSON_COUNT=$(docker compose exec -T postgres psql -U 3chan -d lemon_korean -t -c "SELECT COUNT(*) FROM lessons;" 2>/dev/null | tr -d ' ')

echo "📊 Current data counts:"
echo "  - Lessons: $LESSON_COUNT"

# Check user count
USER_COUNT=$(docker compose exec -T postgres psql -U 3chan -d lemon_korean -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null | tr -d ' ')
echo "  - Users: $USER_COUNT"

# Check vocabulary count
VOCAB_COUNT=$(docker compose exec -T postgres psql -U 3chan -d lemon_korean -t -c "SELECT COUNT(*) FROM vocabulary;" 2>/dev/null | tr -d ' ')
echo "  - Vocabulary: $VOCAB_COUNT"

# Warning if lesson count is suspiciously low
if [ "$LESSON_COUNT" -lt 10 ]; then
  echo ""
  echo "⚠️  WARNING: Only $LESSON_COUNT lessons found!"
  echo "   This may indicate data loss."
  exit 1
fi

echo ""
echo "✅ Data integrity check passed"
EOF

chmod +x "$PROJECT_ROOT/scripts/monitoring/check-data-integrity.sh"
echo "✅ Data integrity check script created"

# 7. Cron 작업 안내
echo ""
echo "================================================"
echo "📋 Next Steps: Set up automated backups"
echo "================================================"
echo ""
echo "Run the following command to edit your crontab:"
echo "  crontab -e"
echo ""
echo "Then add these lines:"
echo ""
echo "# Lemon Korean - Daily backup at 2 AM"
echo "0 2 * * * cd $PROJECT_ROOT && ./scripts/backup/backup-all.sh >> /var/log/lemon-backup.log 2>&1"
echo ""
echo "# Lemon Korean - Volume check every hour"
echo "0 * * * * cd $PROJECT_ROOT && ./scripts/monitoring/check-volumes.sh >> /var/log/lemon-monitor.log 2>&1"
echo ""
echo "# Lemon Korean - Data integrity check every 6 hours"
echo "0 */6 * * * cd $PROJECT_ROOT && ./scripts/monitoring/check-data-integrity.sh >> /var/log/lemon-monitor.log 2>&1"
echo ""
echo "================================================"
echo ""

# 8. 완료 메시지
echo "✅ Safety setup completed!"
echo ""
echo "⚠️  IMPORTANT:"
echo "  1. Restart your shell or run: source $SHELL_CONFIG"
echo "  2. Set up cron jobs (see instructions above)"
echo "  3. Test the backup: ./scripts/backup/backup-all.sh"
echo "  4. Read: DATA_LOSS_ANALYSIS.md for detailed prevention guide"
echo ""
echo "🛡️  Your data is now better protected!"
