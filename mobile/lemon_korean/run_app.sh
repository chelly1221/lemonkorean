#!/bin/bash
# Start emulator and wait for it to boot
echo "Starting emulator..."
/home/sanchan/Android/Sdk/emulator/emulator -avd lemon_korean_emulator -no-snapshot-load &
EMULATOR_PID=$!

# Wait for device to be ready
echo "Waiting for emulator to boot..."
adb wait-for-device
sleep 10

# Run Flutter app
echo "Running Flutter app..."
cd /home/sanchan/lemonkorean/mobile/lemon_korean
flutter run

# Cleanup
kill $EMULATOR_PID 2>/dev/null
