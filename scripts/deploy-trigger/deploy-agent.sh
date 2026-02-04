#!/bin/bash
#
# Deploy Agent - Monitors for deployment triggers and executes builds
# This script runs on the HOST machine and watches for deployment requests
#

TRIGGER_DIR="/home/sanchan/lemonkorean/services/admin/src/deploy-triggers"
BUILD_SCRIPT="/home/sanchan/lemonkorean/mobile/lemon_korean/build_web.sh"
LOG_FILE="$TRIGGER_DIR/agent.log"

# Ensure trigger directory exists
mkdir -p "$TRIGGER_DIR"

echo "[$(date)] Deploy agent started, monitoring $TRIGGER_DIR" >> "$LOG_FILE"
echo "[$(date)] Deploy agent started, monitoring $TRIGGER_DIR"

while true; do
    # Check for trigger file
    if [ -f "$TRIGGER_DIR/deploy.trigger" ]; then
        DEPLOYMENT_ID=$(cat "$TRIGGER_DIR/deploy.trigger")
        echo "[$(date)] Deployment triggered: ID=$DEPLOYMENT_ID" >> "$LOG_FILE"

        # Remove trigger file
        rm "$TRIGGER_DIR/deploy.trigger"

        # Create log file for this deployment
        DEPLOY_LOG="$TRIGGER_DIR/deploy-$DEPLOYMENT_ID.log"
        echo "Starting deployment $DEPLOYMENT_ID" > "$DEPLOY_LOG"

        # Execute build script
        echo "[$(date)] Executing build script..." >> "$DEPLOY_LOG"
        bash "$BUILD_SCRIPT" >> "$DEPLOY_LOG" 2>&1
        EXIT_CODE=$?

        if [ $EXIT_CODE -eq 0 ]; then
            echo "[$(date)] Deployment completed successfully" >> "$DEPLOY_LOG"
            echo "SUCCESS" > "$TRIGGER_DIR/deploy-$DEPLOYMENT_ID.status"
        else
            echo "[$(date)] Deployment failed with exit code $EXIT_CODE" >> "$DEPLOY_LOG"
            echo "FAILED" > "$TRIGGER_DIR/deploy-$DEPLOYMENT_ID.status"
        fi

        echo "[$(date)] Deployment $DEPLOYMENT_ID finished with exit code $EXIT_CODE" >> "$LOG_FILE"
    fi

    sleep 2
done
