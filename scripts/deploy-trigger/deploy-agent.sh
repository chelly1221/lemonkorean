#!/bin/bash
#
# Deploy Agent - Monitors for deployment triggers and executes builds
# This script runs on the HOST machine and watches for deployment requests
#

TRIGGER_DIR="/home/sanchan/lemonkorean/services/admin/src/deploy-triggers"
WEB_BUILD_SCRIPT="/home/sanchan/lemonkorean/mobile/lemon_korean/build_web.sh"
APK_BUILD_SCRIPT="/home/sanchan/lemonkorean/mobile/lemon_korean/build_apk.sh"
LOG_FILE="$TRIGGER_DIR/agent.log"

# Ensure trigger directory exists
mkdir -p "$TRIGGER_DIR"

echo "[$(date)] Deploy agent started, monitoring $TRIGGER_DIR" >> "$LOG_FILE"
echo "[$(date)] Deploy agent started, monitoring $TRIGGER_DIR"

while true; do
    # Check for web deployment trigger
    if [ -f "$TRIGGER_DIR/deploy.trigger" ]; then
        DEPLOYMENT_ID=$(cat "$TRIGGER_DIR/deploy.trigger")
        echo "[$(date)] Web deployment triggered: ID=$DEPLOYMENT_ID" >> "$LOG_FILE"

        # Remove trigger file
        rm "$TRIGGER_DIR/deploy.trigger"

        # Create log file for this deployment
        DEPLOY_LOG="$TRIGGER_DIR/deploy-$DEPLOYMENT_ID.log"
        echo "Starting web deployment $DEPLOYMENT_ID" > "$DEPLOY_LOG"

        # Execute build script
        echo "[$(date)] Executing web build script..." >> "$DEPLOY_LOG"
        bash "$WEB_BUILD_SCRIPT" >> "$DEPLOY_LOG" 2>&1
        EXIT_CODE=$?

        if [ $EXIT_CODE -eq 0 ]; then
            echo "[$(date)] Web deployment completed successfully" >> "$DEPLOY_LOG"
            echo "SUCCESS" > "$TRIGGER_DIR/deploy-$DEPLOYMENT_ID.status"
        else
            echo "[$(date)] Web deployment failed with exit code $EXIT_CODE" >> "$DEPLOY_LOG"
            echo "FAILED" > "$TRIGGER_DIR/deploy-$DEPLOYMENT_ID.status"
        fi

        echo "[$(date)] Web deployment $DEPLOYMENT_ID finished with exit code $EXIT_CODE" >> "$LOG_FILE"
    fi

    # Check for APK build trigger
    if [ -f "$TRIGGER_DIR/apk-build.trigger" ]; then
        BUILD_ID=$(cat "$TRIGGER_DIR/apk-build.trigger")
        echo "[$(date)] APK build triggered: ID=$BUILD_ID" >> "$LOG_FILE"

        # Remove trigger file
        rm "$TRIGGER_DIR/apk-build.trigger"

        # Create log file for this build
        BUILD_LOG="$TRIGGER_DIR/apk-build-$BUILD_ID.log"
        echo "Starting APK build $BUILD_ID" > "$BUILD_LOG"

        # Execute APK build script
        echo "[$(date)] Executing APK build script..." >> "$BUILD_LOG"
        bash "$APK_BUILD_SCRIPT" >> "$BUILD_LOG" 2>&1
        EXIT_CODE=$?

        if [ $EXIT_CODE -eq 0 ]; then
            echo "[$(date)] APK build completed successfully" >> "$BUILD_LOG"
            echo "SUCCESS" > "$TRIGGER_DIR/apk-build-$BUILD_ID.status"
        else
            echo "[$(date)] APK build failed with exit code $EXIT_CODE" >> "$BUILD_LOG"
            echo "FAILED" > "$TRIGGER_DIR/apk-build-$BUILD_ID.status"
        fi

        echo "[$(date)] APK build $BUILD_ID finished with exit code $EXIT_CODE" >> "$LOG_FILE"
    fi

    sleep 2
done
