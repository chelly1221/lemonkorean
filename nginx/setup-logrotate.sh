#!/bin/bash

# ================================================================
# Nginx Log Rotation Setup Script
# ================================================================
# This script installs and configures logrotate for nginx logs
# ================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOGROTATE_CONFIG="$SCRIPT_DIR/logrotate.conf"
LOGROTATE_DEST="/etc/logrotate.d/lemon-nginx"

echo "================================================"
echo "Nginx Log Rotation Setup"
echo "================================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
    echo "⚠️  This script requires sudo privileges"
fi

# Check if logrotate is installed
if ! command -v logrotate &> /dev/null; then
    echo "❌ logrotate is not installed"
    echo ""
    echo "Install with:"
    echo "  sudo apt-get update && sudo apt-get install logrotate"
    exit 1
fi

echo "✅ logrotate is installed: $(logrotate --version | head -1)"
echo ""

# Check if nginx container is running
if ! docker ps | grep -q lemon-nginx; then
    echo "⚠️  Warning: nginx container is not running"
    echo "   The container must be running for log rotation to work"
    echo ""
fi

# Copy configuration
echo "📝 Installing logrotate configuration..."
$SUDO cp "$LOGROTATE_CONFIG" "$LOGROTATE_DEST"
$SUDO chmod 644 "$LOGROTATE_DEST"
echo "   ✅ Copied to: $LOGROTATE_DEST"
echo ""

# Test configuration
echo "🧪 Testing logrotate configuration..."
$SUDO logrotate -d "$LOGROTATE_DEST" 2>&1 | head -20
echo ""

# Show current log sizes
echo "📊 Current log file sizes:"
if [ -d "$SCRIPT_DIR/logs" ]; then
    du -h "$SCRIPT_DIR/logs"/*.log 2>/dev/null || echo "   No log files found"
else
    echo "   Log directory not found: $SCRIPT_DIR/logs"
fi
echo ""

# Create logs directory if it doesn't exist
if [ ! -d "$SCRIPT_DIR/logs" ]; then
    echo "📁 Creating logs directory..."
    mkdir -p "$SCRIPT_DIR/logs"
    echo "   ✅ Created: $SCRIPT_DIR/logs"
    echo ""
fi

# Check if logrotate cron is configured
if [ -f /etc/cron.daily/logrotate ]; then
    echo "✅ logrotate daily cron is configured"
    echo "   Location: /etc/cron.daily/logrotate"
else
    echo "⚠️  Warning: /etc/cron.daily/logrotate not found"
    echo "   Automatic rotation may not work"
fi
echo ""

# Manual rotation command
echo "================================================"
echo "✅ Setup Complete!"
echo "================================================"
echo ""
echo "Log rotation is now configured with:"
echo "  • Daily rotation"
echo "  • 14 days retention (access logs)"
echo "  • 30 days retention (error logs)"
echo "  • Automatic compression"
echo "  • Nginx reload after rotation"
echo ""
echo "Commands:"
echo "  • Test:  sudo logrotate -d $LOGROTATE_DEST"
echo "  • Force: sudo logrotate -f $LOGROTATE_DEST"
echo "  • Check: ls -lh $SCRIPT_DIR/logs/"
echo ""
echo "Automatic rotation runs daily via cron."
echo ""
