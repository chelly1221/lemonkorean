# Deploy Agent System

File-based trigger system for automated web and APK deployments.

## Overview

The deploy agent (`deploy-agent.sh`) runs as a systemd service on the host machine, monitoring for trigger files and executing build scripts.

## Architecture

```
Admin Dashboard → Create trigger file → Deploy Agent → Execute build script → Update status
```

## Trigger Files

**Directory:** `/home/sanchan/lemonkorean/services/admin/src/deploy-triggers/`

### Web Deployment
- **Trigger:** `deploy.trigger` (contains deployment ID)
- **Log:** `deploy-{ID}.log`
- **Status:** `deploy-{ID}.status` (SUCCESS/FAILED)
- **Script:** `/home/sanchan/lemonkorean/mobile/lemon_korean/build_web.sh`

### APK Build
- **Trigger:** `apk-build.trigger` (contains build ID)
- **Log:** `apk-build-{ID}.log`
- **Status:** `apk-build-{ID}.status` (SUCCESS/FAILED)
- **Script:** `/home/sanchan/lemonkorean/mobile/lemon_korean/build_apk.sh`

## Systemd Service Setup

**Service file:** `/etc/systemd/system/deploy-agent.service`

```ini
[Unit]
Description=Lemon Korean Deploy Agent
After=network.target

[Service]
Type=simple
User=sanchan
WorkingDirectory=/home/sanchan/lemonkorean
ExecStart=/bin/bash -l /home/sanchan/lemonkorean/scripts/deploy-trigger/deploy-agent.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Important:** The `-l` flag ensures proper PATH environment for Flutter SDK.

## How It Works

1. Admin triggers deployment via Admin Dashboard
2. Admin service creates trigger file with deployment/build ID
3. Deploy agent detects trigger file (2-second polling)
4. Agent removes trigger file and creates log file
5. Agent executes corresponding build script
6. Agent writes status file (SUCCESS/FAILED) based on exit code
7. Admin service polls status file and updates database

## Cancellation

Deployments can be cancelled by creating:
- `deploy-{ID}.cancel` for web deployments
- `apk-build-{ID}.cancel` for APK builds

The build scripts check for these files and terminate gracefully.

## Monitoring

**Agent log:** `/home/sanchan/lemonkorean/services/admin/src/deploy-triggers/agent.log`

```bash
# View agent status
sudo systemctl status deploy-agent

# View agent logs
tail -f /home/sanchan/lemonkorean/services/admin/src/deploy-triggers/agent.log

# Restart agent
sudo systemctl restart deploy-agent
```

## Security

- Agent runs as `sanchan` user (non-root)
- Trigger directory is monitored only (no external input)
- Build scripts validate Flutter SDK availability
- All outputs logged for audit

## Troubleshooting

**Agent not detecting triggers:**
- Check systemd service status
- Verify trigger directory permissions
- Check agent.log for errors

**Builds failing:**
- Check deployment/build log files
- Verify Flutter SDK in PATH
- Ensure NAS mount is available (`/mnt/nas/lemon/`)

---

**Last Updated:** 2026-02-05
