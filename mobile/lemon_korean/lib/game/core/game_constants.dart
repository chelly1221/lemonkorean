/// Constants used across the FLAME game components.
class GameConstants {
  // Spritesheet frame dimensions (pixels)
  static const double frameWidth = 32;
  static const double frameHeight = 48;

  // Display scale (rendered at 3x native)
  static const double displayScale = 3.0;
  static const double displayWidth = frameWidth * displayScale;   // 96
  static const double displayHeight = frameHeight * displayScale; // 144

  // Spritesheet layout
  static const int walkFrames = 4;
  static const int idleFrames = 1;
  static const int columnsPerRow = idleFrames + walkFrames; // 5

  // Row indices per direction
  static const int rowFront = 0;
  static const int rowBack = 1;
  static const int rowRight = 2;
  static const int rowGestures = 3;
  // Left = horizontal flip of Right

  // Gesture frame offsets in row 3
  static const int gestureJumpStart = 0;
  static const int gestureJumpFrames = 4;
  static const int gestureWaveStart = 4;
  static const int gestureWaveFrames = 4;
  static const int gestureBowStart = 8;
  static const int gestureBowFrames = 3;
  static const int gestureDanceStart = 11;
  static const int gestureDanceFrames = 6;
  static const int gestureClapStart = 17;
  static const int gestureClapFrames = 4;

  // Walk animation
  static const double walkFps = 8.0;
  static const double walkStepTime = 1.0 / walkFps;
  static const double walkSpeed = 250.0; // px/sec

  // Floor bounds (normalized 0-1)
  static const double floorTopFraction = 0.65;
  static const double floorBottomFraction = 0.92;

  // Voice stage bounds (normalized 0-1)
  static const double stageMinX = 0.05;
  static const double stageMaxX = 0.95;
  static const double stageMinY = 0.3;
  static const double stageMaxY = 0.9;

  // Render order (matches SVG layer order)
  static const int renderOrderBody = 0;
  static const int renderOrderEyes = 20;
  static const int renderOrderEyebrows = 25;
  static const int renderOrderNose = 30;
  static const int renderOrderMouth = 35;
  static const int renderOrderHair = 40;
  static const int renderOrderTop = 50;
  static const int renderOrderBottom = 55;
  static const int renderOrderShoes = 60;
  static const int renderOrderHat = 70;
  static const int renderOrderAccessory = 80;

  // Face categories hidden when facing back
  static const Set<String> faceCategories = {
    'eyes', 'eyebrows', 'nose', 'mouth',
  };

  // Position throttle for network sync (10Hz)
  static const Duration positionThrottle = Duration(milliseconds: 100);
  static const double positionMinDelta = 0.005;

  // Remote character interpolation speed
  static const double remoteInterpolationSpeed = 0.02;

  // Particle defaults
  static const double reactionFloatSpeed = 30.0; // px/sec upward
  static const double reactionLifetime = 2.0; // seconds
  static const double speakingAuraPulseSpeed = 2.0; // cycles/sec

  // Day/night overlay
  static const double dayNightMaxAlpha = 0.15;

  // Pet
  static const double petWanderSpeed = 60.0; // px/sec
  static const double petFollowDistance = 40.0; // px
  static const double petFollowSpeed = 100.0; // px/sec
}
