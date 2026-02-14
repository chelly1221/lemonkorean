import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../core/services/socket_service.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/voice_room_model.dart';
import '../../data/repositories/voice_room_repository.dart';
import '../../game/core/game_bridge.dart';

/// State for a character on the stage
class StageCharacterState {
  final int userId;
  final String name;
  final String? avatar;
  final Map<String, dynamic>? equippedItems;
  final String? skinColor;
  double x;
  double y;
  String direction;
  double targetX;
  double targetY;
  bool isMuted;
  String connectionQuality; // 'excellent', 'good', 'poor', 'lost', 'unknown'

  // Gesture state
  String? activeGesture;
  DateTime? gestureStartTime;

  StageCharacterState({
    required this.userId,
    required this.name,
    this.avatar,
    this.equippedItems,
    this.skinColor,
    this.x = 0.5,
    this.y = 0.75,
    this.direction = 'front',
    this.targetX = 0.5,
    this.targetY = 0.75,
    this.isMuted = false,
    this.connectionQuality = 'unknown',
    this.activeGesture,
    this.gestureStartTime,
  });
}

/// Floating reaction animation state
class FloatingReaction {
  final String emoji;
  final int userId;
  final String? userName;
  final double startX;
  final double startY;
  final DateTime createdAt;

  FloatingReaction({
    required this.emoji,
    required this.userId,
    this.userName,
    required this.startX,
    required this.startY,
    required this.createdAt,
  });
}

/// Provider for voice room state management with stage/audience system
class VoiceRoomProvider with ChangeNotifier {
  final VoiceRoomRepository _repository = VoiceRoomRepository();
  final SocketService _socket = SocketService.instance;

  // Room list state
  List<VoiceRoomModel> _rooms = [];
  bool _isLoading = false;
  String? _error;

  // Active room state
  VoiceRoomModel? _activeRoom;
  String? _livekitToken;
  String? _livekitUrl;
  bool _isMuted = false;

  // Stage/audience state
  String _myRole = 'listener';
  List<VoiceParticipantModel> _speakers = [];
  List<VoiceParticipantModel> _listeners = [];
  List<VoiceChatMessageModel> _messages = [];
  List<StageRequestModel> _stageRequests = [];
  bool _hasRaisedHand = false;

  // Stage character positions
  final Map<int, StageCharacterState> _stageCharacters = {};
  double _myStageX = 0.5;
  double _myStageY = 0.75;
  String _myStageDirection = 'front';

  // Floating reactions
  final List<FloatingReaction> _reactions = [];

  // Position update throttle
  DateTime? _lastPositionSent;
  static const Duration _positionThrottle = Duration(milliseconds: 100);
  static const double _positionMinDelta = 0.005;

  // Gesture cooldown
  DateTime? _lastGestureSent;
  static const Duration _gestureCooldown = Duration(seconds: 3);

  // LiveKit state
  lk.Room? _livekitRoom;
  lk.EventsListener<lk.RoomEvent>? _roomListener;
  bool _isConnecting = false;
  bool _isConnected = false;

  // Reconnection state
  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;
  Timer? _reconnectTimer;

  // Socket.IO subscriptions
  final List<StreamSubscription> _socketSubscriptions = [];

  // Chat scroll controller callback
  VoidCallback? onNewMessageReceived;

  // Getters
  List<VoiceRoomModel> get rooms => _rooms;
  VoiceRoomModel? get activeRoom => _activeRoom;
  List<VoiceParticipantModel> get speakers => _speakers;
  List<VoiceParticipantModel> get listeners => _listeners;
  List<VoiceChatMessageModel> get messages => _messages;
  List<StageRequestModel> get stageRequests => _stageRequests;
  Map<int, StageCharacterState> get stageCharacters => _stageCharacters;
  List<FloatingReaction> get reactions => _reactions;
  String? get livekitToken => _livekitToken;
  String? get livekitUrl => _livekitUrl;
  bool get isLoading => _isLoading;
  bool get isMuted => _isMuted;
  String? get error => _error;
  bool get isInRoom => _activeRoom != null;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;
  bool get isReconnecting => _isReconnecting;
  int get reconnectAttempts => _reconnectAttempts;
  String get myRole => _myRole;
  bool get isSpeaker => _myRole == 'speaker';
  bool get isListener => _myRole == 'listener';
  bool get hasRaisedHand => _hasRaisedHand;
  double get myStageX => _myStageX;
  double get myStageY => _myStageY;
  String get myStageDirection => _myStageDirection;

  bool get isCreator =>
      _activeRoom != null && _activeRoom!.creatorId == _myUserId;
  int? _myUserId;

  // GameBridge for Flame integration
  GameBridge? _gameBridge;
  StreamSubscription? _bridgeFlutterSub;

  /// Lazily creates and returns the GameBridge for voice stage.
  GameBridge get gameBridge {
    _gameBridge ??= GameBridge();
    return _gameBridge!;
  }

  /// Attach the bridge and start listening for Flame → Flutter events.
  void attachGameBridge() {
    _bridgeFlutterSub?.cancel();
    _bridgeFlutterSub = gameBridge.flutterEvents.listen((event) {
      if (event is LocalCharacterMoved) {
        updateMyStagePosition(event.x, event.y, event.direction);
      }
    });
  }

  /// Detach the bridge and clean up.
  void detachGameBridge() {
    _bridgeFlutterSub?.cancel();
    _bridgeFlutterSub = null;
    _gameBridge?.dispose();
    _gameBridge = null;
  }

  void setMyUserId(int userId) {
    _myUserId = userId;
  }

  // ==========================================================================
  // LiveKit Connection
  // ==========================================================================

  Future<void> _connectToLiveKit() async {
    if (_livekitToken == null || _livekitUrl == null) {
      _error = 'Missing LiveKit credentials';
      notifyListeners();
      return;
    }

    _isConnecting = true;
    _error = null;
    notifyListeners();

    try {
      _livekitRoom = lk.Room(
        roomOptions: const lk.RoomOptions(
          defaultAudioPublishOptions: lk.AudioPublishOptions(dtx: true),
          defaultAudioCaptureOptions: lk.AudioCaptureOptions(
            echoCancellation: true,
            noiseSuppression: true,
            autoGainControl: true,
            highPassFilter: true,
          ),
        ),
      );

      _roomListener = _livekitRoom!.createListener();

      _roomListener!
        ..on<lk.RoomConnectedEvent>((_) {
          _isConnecting = false;
          _isConnected = true;
          _isReconnecting = false;
          _reconnectAttempts = 0;
          _error = null;
          notifyListeners();
        })
        ..on<lk.RoomDisconnectedEvent>((_) {
          _isConnected = false;
          _isConnecting = false;
          notifyListeners();
          if (_activeRoom != null) {
            _attemptReconnect();
          }
        })
        ..on<lk.ParticipantConnectedEvent>((_) => refreshParticipants())
        ..on<lk.ParticipantDisconnectedEvent>((_) => refreshParticipants())
        ..on<lk.TrackMutedEvent>((_) => refreshParticipants())
        ..on<lk.TrackUnmutedEvent>((_) => refreshParticipants())
        ..on<lk.ParticipantPermissionsUpdatedEvent>((event) async {
          // Server updated our permissions in-place (promotion/demotion)
          final canPublish = event.permissions.canPublish;
          AppLogger.i(
            'Permissions updated: canPublish=$canPublish',
            tag: 'VoiceRoomProvider',
          );
          if (canPublish && _myRole == 'speaker') {
            // Promoted — enable mic
            try {
              await _livekitRoom?.localParticipant
                  ?.setMicrophoneEnabled(true);
            } catch (e) {
              AppLogger.w('Mic enable after permission update failed',
                  tag: 'VoiceRoomProvider', error: e);
            }
          } else if (!canPublish && _myRole == 'listener') {
            // Demoted — ensure mic is off
            try {
              await _livekitRoom?.localParticipant
                  ?.setMicrophoneEnabled(false);
            } catch (_) {}
          }
          notifyListeners();
        })
        ..on<lk.ParticipantConnectionQualityUpdatedEvent>((event) {
          final identity = event.participant.identity;
          // Parse userId from identity format "user_123"
          final idStr = identity.startsWith('user_')
              ? identity.substring(5)
              : identity;
          final userId = int.tryParse(idStr);
          if (userId == null) return;
          final quality = event.connectionQuality.name; // excellent, good, poor, lost, unknown
          if (_stageCharacters.containsKey(userId)) {
            _stageCharacters[userId]!.connectionQuality = quality;
          }
          _gameBridge?.sendToGame(ConnectionQualityChanged(
            userId: userId,
            quality: quality,
          ));
          notifyListeners();
        });

      await _livekitRoom!
          .connect(_livekitUrl!, _livekitToken!)
          .timeout(const Duration(seconds: 15));

      // Only enable mic for speakers
      if (isSpeaker) {
        try {
          await _livekitRoom!.localParticipant?.setMicrophoneEnabled(true);
        } catch (micError) {
          AppLogger.w('Microphone enable failed',
              tag: 'VoiceRoomProvider', error: micError);
        }
      }
    } on TimeoutException {
      _isConnecting = false;
      _isConnected = false;
      _error = 'Connection timed out';
      _livekitRoom?.dispose();
      _livekitRoom = null;
      _roomListener?.dispose();
      _roomListener = null;
      notifyListeners();
    } catch (e) {
      AppLogger.e('LiveKit connection error',
          tag: 'VoiceRoomProvider', error: e);
      _isConnecting = false;
      _isConnected = false;
      _error = 'Failed to connect to voice server';
      _livekitRoom?.dispose();
      _livekitRoom = null;
      _roomListener?.dispose();
      _roomListener = null;
      notifyListeners();
    }
  }

  void _attemptReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _isReconnecting = false;
      _error = 'Connection lost. Tap to retry.';
      notifyListeners();
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;
    notifyListeners();

    final delay = Duration(seconds: 1 << _reconnectAttempts);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () async {
      if (_activeRoom == null) return;
      _roomListener?.dispose();
      _roomListener = null;
      _livekitRoom?.dispose();
      _livekitRoom = null;
      await _connectToLiveKit();
      if (!_isConnected && _activeRoom != null) {
        _attemptReconnect();
      }
    });
  }

  Future<void> reconnect() async {
    if (_activeRoom == null) return;
    _reconnectAttempts = 0;
    _error = null;
    _isReconnecting = false;
    _roomListener?.dispose();
    _roomListener = null;
    _livekitRoom?.dispose();
    _livekitRoom = null;
    await _connectToLiveKit();
  }

  void _cleanupLiveKit() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isReconnecting = false;
    _reconnectAttempts = 0;
    _roomListener?.dispose();
    _roomListener = null;
    _livekitRoom?.disconnect();
    _livekitRoom?.dispose();
    _livekitRoom = null;
    _isConnecting = false;
    _isConnected = false;
    notifyListeners();
  }

  // ==========================================================================
  // Socket.IO Event Listeners
  // ==========================================================================

  void _setupSocketListeners() {
    _cleanupSocketListeners();

    _socketSubscriptions.add(
      _socket.onVoiceParticipantJoined.listen((data) {
        if (_activeRoom != null && data['room_id'] == _activeRoom!.id) {
          final role = data['role']?.toString() ?? 'listener';
          final participant = VoiceParticipantModel(
            userId: data['user_id'] as int,
            name: (data['name'] ?? '').toString(),
            avatar: data['avatar']?.toString(),
            role: role,
          );
          if (role == 'listener') {
            _listeners.add(participant);
          }
          notifyListeners();
        }
      }),
    );

    _socketSubscriptions.add(
      _socket.onVoiceParticipantLeft.listen((data) {
        if (_activeRoom != null && data['room_id'] == _activeRoom!.id) {
          final userId = data['user_id'] as int;
          _speakers.removeWhere((p) => p.userId == userId);
          _listeners.removeWhere((p) => p.userId == userId);
          _stageCharacters.remove(userId);
          // Forward to Flame
          _gameBridge?.sendToGame(RemoteCharacterRemoved(userId: userId));
          notifyListeners();
        }
      }),
    );

    _socketSubscriptions.add(
      _socket.onVoiceParticipantMuted.listen((data) {
        if (_activeRoom != null && data['room_id'] == _activeRoom!.id) {
          final userId = data['user_id'] as int?;
          final muted = data['is_muted'] as bool?;
          if (userId != null && muted != null) {
            final idx = _speakers.indexWhere((p) => p.userId == userId);
            if (idx >= 0) {
              _speakers[idx] = VoiceParticipantModel(
                userId: _speakers[idx].userId,
                name: _speakers[idx].name,
                avatar: _speakers[idx].avatar,
                isMuted: muted,
                role: 'speaker',
                equippedItems: _speakers[idx].equippedItems,
                skinColor: _speakers[idx].skinColor,
              );
              // Also update stage character mute state
              if (_stageCharacters.containsKey(userId)) {
                _stageCharacters[userId]!.isMuted = muted;
              }
              // Forward to Flame
              _gameBridge?.sendToGame(MuteStateChanged(
                userId: userId,
                isMuted: muted,
              ));
              notifyListeners();
            }
          }
        }
      }),
    );

    _socketSubscriptions.add(
      _socket.onVoiceRoomClosed.listen((data) {
        if (_activeRoom != null && data['room_id'] == _activeRoom!.id) {
          _cleanupLiveKit();
          _cleanupSocketListeners();
          _activeRoom = null;
          _livekitToken = null;
          _livekitUrl = null;
          _speakers = [];
          _listeners = [];
          _messages = [];
          _stageRequests = [];
          _stageCharacters.clear();
          _reactions.clear();
          _isMuted = false;
          _myRole = 'listener';
          _hasRaisedHand = false;
          _error = 'Room was closed by the host';
          notifyListeners();
        }
      }),
    );

    // New message
    _socketSubscriptions.add(
      _socket.onVoiceNewMessage.listen((data) {
        if (_activeRoom != null && (data['room_id'] == _activeRoom!.id || data['room_id'] == null)) {
          _messages.add(VoiceChatMessageModel.fromJson(data));
          notifyListeners();
          onNewMessageReceived?.call();
        }
      }),
    );

    // Role changed
    _socketSubscriptions.add(
      _socket.onVoiceRoleChanged.listen((data) {
        if (_activeRoom == null) return;
        final userId = data['user_id'] as int?;
        final newRole = data['role']?.toString();
        if (userId == null || newRole == null) return;

        if (newRole == 'speaker') {
          // Move from listeners to speakers
          final listenerIdx = _listeners.indexWhere((p) => p.userId == userId);
          VoiceParticipantModel? participant;
          if (listenerIdx >= 0) {
            participant = _listeners.removeAt(listenerIdx);
          }
          final speaker = VoiceParticipantModel(
            userId: userId,
            name: participant?.name ?? '',
            avatar: participant?.avatar,
            role: 'speaker',
            equippedItems: data['equipped_items'] is Map
                ? Map<String, dynamic>.from(data['equipped_items'])
                : participant?.equippedItems,
            skinColor: data['skin_color']?.toString() ?? participant?.skinColor,
          );
          _speakers.add(speaker);

          // Add to stage characters
          _stageCharacters[userId] = StageCharacterState(
            userId: userId,
            name: speaker.name,
            avatar: speaker.avatar,
            equippedItems: speaker.equippedItems,
            skinColor: speaker.skinColor,
          );
          // Forward to Flame
          _gameBridge?.sendToGame(RemoteCharacterAdded(
            userId: userId,
            name: speaker.name,
            equippedItems: speaker.equippedItems,
            skinColor: speaker.skinColor,
          ));
        } else {
          // Move from speakers to listeners
          final speakerIdx = _speakers.indexWhere((p) => p.userId == userId);
          VoiceParticipantModel? participant;
          if (speakerIdx >= 0) {
            participant = _speakers.removeAt(speakerIdx);
          }
          _listeners.add(VoiceParticipantModel(
            userId: userId,
            name: participant?.name ?? '',
            avatar: participant?.avatar,
            role: 'listener',
          ));
          _stageCharacters.remove(userId);
          // Forward to Flame
          _gameBridge?.sendToGame(RemoteCharacterRemoved(userId: userId));
        }

        // Update own role
        if (userId == _myUserId) {
          _myRole = newRole;
          if (newRole == 'listener') {
            _hasRaisedHand = false;
          }
        }

        notifyListeners();
      }),
    );

    // Stage request (raise hand)
    _socketSubscriptions.add(
      _socket.onVoiceStageRequest.listen((data) {
        if (_activeRoom != null && data['room_id'] == _activeRoom!.id) {
          _stageRequests.add(StageRequestModel(
            id: 0,
            roomId: data['room_id'] as int,
            userId: data['user_id'] as int,
            name: (data['name'] ?? '').toString(),
            avatar: data['avatar']?.toString(),
            createdAt: DateTime.now(),
          ));
          notifyListeners();
        }
      }),
    );

    // Stage request cancelled
    _socketSubscriptions.add(
      _socket.onVoiceStageRequestCancelled.listen((data) {
        if (_activeRoom != null && data['room_id'] == _activeRoom!.id) {
          _stageRequests.removeWhere((r) => r.userId == data['user_id']);
          notifyListeners();
        }
      }),
    );

    // Stage granted (promoted to speaker — permissions updated server-side)
    _socketSubscriptions.add(
      _socket.onVoiceStageGranted.listen((data) async {
        if (_activeRoom == null) return;
        final userId = data['user_id'] as int?;
        if (userId == _myUserId) {
          // I was promoted to speaker
          _myRole = 'speaker';
          _hasRaisedHand = false;
          final newToken = data['livekit_token'] as String?;
          if (newToken != null) {
            _livekitToken = newToken; // Save as fallback
          }
          // Server already updated permissions in-place via LiveKit API.
          // The ParticipantPermissionsUpdatedEvent listener will enable mic.
          // If LiveKit room is not connected, fall back to reconnect.
          if (_livekitRoom == null || !_isConnected) {
            await _connectToLiveKit();
          } else {
            // Ensure mic is enabled (in case permission event hasn't fired yet)
            try {
              await _livekitRoom!.localParticipant
                  ?.setMicrophoneEnabled(true);
              _isMuted = false;
            } catch (e) {
              AppLogger.w('Mic enable on stage grant failed',
                  tag: 'VoiceRoomProvider', error: e);
            }
          }
          notifyListeners();
        }
        // Remove from stage requests
        _stageRequests.removeWhere((r) => r.userId == userId);
        notifyListeners();
      }),
    );

    // Stage removed (demoted to listener — permissions revoked server-side)
    _socketSubscriptions.add(
      _socket.onVoiceStageRemoved.listen((data) async {
        if (_activeRoom == null) return;
        final userId = data['user_id'] as int?;
        if (userId == _myUserId) {
          _myRole = 'listener';
          final newToken = data['livekit_token'] as String?;
          if (newToken != null) {
            _livekitToken = newToken; // Save as fallback
          }
          // Server already revoked permissions via LiveKit API — no reconnect needed.
          // Just ensure mic is disabled.
          try {
            await _livekitRoom?.localParticipant
                ?.setMicrophoneEnabled(false);
          } catch (_) {}
          _isMuted = false;
          notifyListeners();
        }
      }),
    );

    // Character position updates from other users
    _socketSubscriptions.add(
      _socket.onVoiceCharacterPosition.listen((data) {
        final userId = data['user_id'] as int?;
        if (userId == null || userId == _myUserId) return;

        if (_stageCharacters.containsKey(userId)) {
          final char = _stageCharacters[userId]!;
          final x = (data['x'] as num?)?.toDouble() ?? char.x;
          final y = (data['y'] as num?)?.toDouble() ?? char.y;
          final direction = data['direction']?.toString() ?? char.direction;
          char.targetX = x;
          char.targetY = y;
          char.direction = direction;
          // Forward to Flame
          _gameBridge?.sendToGame(RemoteCharacterMoved(
            userId: userId,
            x: x,
            y: y,
            direction: direction,
          ));
          notifyListeners();
        }
      }),
    );

    // Emoji reactions
    _socketSubscriptions.add(
      _socket.onVoiceReaction.listen((data) {
        final userId = data['user_id'] as int?;
        final emoji = data['emoji']?.toString();
        if (userId == null || emoji == null) return;

        final stageChar = _stageCharacters[userId];
        final startX = stageChar?.x ?? 0.5;
        final startY = stageChar?.y ?? 0.3;
        _reactions.add(FloatingReaction(
          emoji: emoji,
          userId: userId,
          userName: data['name']?.toString(),
          startX: startX,
          startY: startY,
          createdAt: DateTime.now(),
        ));
        // Forward to Flame
        _gameBridge?.sendToGame(ReactionReceived(
          emoji: emoji,
          userId: userId,
          startX: startX,
          startY: startY,
        ));
        notifyListeners();

        // Remove after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          _reactions.removeWhere((r) =>
              r.userId == userId &&
              DateTime.now().difference(r.createdAt).inMilliseconds > 1800);
          notifyListeners();
        });
      }),
    );

    // Participant kicked
    _socketSubscriptions.add(
      _socket.onVoiceParticipantKicked.listen((data) {
        if (_activeRoom == null) return;
        if (data['room_id'] != _activeRoom!.id) return;
        final userId = data['user_id'] as int?;
        if (userId == _myUserId) {
          // I was kicked — full cleanup
          _cleanupLiveKit();
          _cleanupSocketListeners();
          _activeRoom = null;
          _livekitToken = null;
          _livekitUrl = null;
          _speakers = [];
          _listeners = [];
          _messages = [];
          _stageRequests = [];
          _stageCharacters.clear();
          _reactions.clear();
          _isMuted = false;
          _myRole = 'listener';
          _hasRaisedHand = false;
          _error = 'You were removed from the room by the host';
          notifyListeners();
        }
      }),
    );

    // Character gestures
    _socketSubscriptions.add(
      _socket.onVoiceGesture.listen((data) {
        final userId = data['user_id'] as int?;
        final gesture = data['gesture']?.toString();
        if (userId == null || gesture == null) return;

        if (_stageCharacters.containsKey(userId)) {
          _stageCharacters[userId]!.activeGesture = gesture;
          _stageCharacters[userId]!.gestureStartTime = DateTime.now();
          // Forward to Flame
          _gameBridge?.sendToGame(RemoteGestureReceived(
            userId: userId,
            gesture: gesture,
          ));
          notifyListeners();

          // Clear gesture after animation duration
          final duration = _gestureDuration(gesture);
          Future.delayed(duration, () {
            if (_stageCharacters.containsKey(userId) &&
                _stageCharacters[userId]!.activeGesture == gesture) {
              _stageCharacters[userId]!.activeGesture = null;
              _stageCharacters[userId]!.gestureStartTime = null;
              notifyListeners();
            }
          });
        }
      }),
    );
  }

  Duration _gestureDuration(String gesture) {
    switch (gesture) {
      case 'wave':
        return const Duration(milliseconds: 800);
      case 'bow':
        return const Duration(milliseconds: 1000);
      case 'dance':
        return const Duration(milliseconds: 3000);
      case 'jump':
        return const Duration(milliseconds: 600);
      case 'clap':
        return const Duration(milliseconds: 800);
      default:
        return const Duration(milliseconds: 1000);
    }
  }

  void _cleanupSocketListeners() {
    for (final sub in _socketSubscriptions) {
      sub.cancel();
    }
    _socketSubscriptions.clear();
  }

  // ==========================================================================
  // Room List
  // ==========================================================================

  Future<void> loadRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rooms = await _repository.getActiveRooms();
    } catch (e) {
      _error = 'Failed to load rooms';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================================================
  // Room Lifecycle
  // ==========================================================================

  Future<bool> createRoom({
    required String title,
    String? topic,
    String languageLevel = 'all',
    int maxSpeakers = 4,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.createRoom(
        title: title,
        topic: topic,
        languageLevel: languageLevel,
        maxSpeakers: maxSpeakers,
      );

      if (result.room != null) {
        _activeRoom = result.room;
        _livekitToken = result.livekitToken;
        _livekitUrl = result.livekitUrl;
        _myRole = 'speaker';
        _isMuted = false;
        _speakers = result.speakers;
        _listeners = [];
        _messages = [];
        _stageRequests = [];
        _stageCharacters.clear();
        _reactions.clear();
        _hasRaisedHand = false;

        // Add own character to stage
        if (_myUserId != null) {
          final mySpeaker = _speakers.firstWhere(
            (s) => s.userId == _myUserId,
            orElse: () => VoiceParticipantModel(
              userId: _myUserId!,
              name: '',
              role: 'speaker',
            ),
          );
          _stageCharacters[_myUserId!] = StageCharacterState(
            userId: _myUserId!,
            name: mySpeaker.name,
            avatar: mySpeaker.avatar,
            equippedItems: mySpeaker.equippedItems,
            skinColor: mySpeaker.skinColor,
          );
        }

        _socket.joinVoiceRoom(result.room!.id);
        _setupSocketListeners();
        _rooms.insert(0, result.room!);

        _isLoading = false;
        notifyListeners();

        await _connectToLiveKit();
        return true;
      }

      _error = 'Failed to create room';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to create room';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinRoom(int roomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.joinRoom(roomId);

      if (result.livekitToken != null) {
        _livekitToken = result.livekitToken;
        _livekitUrl = result.livekitUrl;
        _myRole = result.role ?? 'listener';
        _isMuted = false;
        _hasRaisedHand = false;

        // Get full room info
        final roomInfo = await _repository.getRoom(roomId);
        _activeRoom = roomInfo.room;
        _speakers = roomInfo.speakers;
        _listeners = roomInfo.listeners;
        _stageRequests = roomInfo.pendingRequests;
        _messages = [];
        _stageCharacters.clear();
        _reactions.clear();

        // Build stage characters from speakers
        for (final speaker in _speakers) {
          _stageCharacters[speaker.userId] = StageCharacterState(
            userId: speaker.userId,
            name: speaker.name,
            avatar: speaker.avatar,
            equippedItems: speaker.equippedItems,
            skinColor: speaker.skinColor,
            isMuted: speaker.isMuted,
          );
        }

        // Load initial messages
        if (_activeRoom != null) {
          _messages = await _repository.getMessages(_activeRoom!.id);
        }

        _socket.joinVoiceRoom(roomId);
        _setupSocketListeners();

        _isLoading = false;
        notifyListeners();

        await _connectToLiveKit();
        return true;
      }

      _error = result.error ?? 'Failed to join room';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to join room';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> leaveRoom() async {
    if (_activeRoom == null) return;

    final roomId = _activeRoom!.id;
    _cleanupLiveKit();
    _socket.leaveVoiceRoom(roomId);
    _cleanupSocketListeners();

    try {
      await _repository.leaveRoom(roomId);
    } catch (e) {
      AppLogger.e('leaveRoom error', tag: 'VoiceRoomProvider', error: e);
    }

    _activeRoom = null;
    _livekitToken = null;
    _livekitUrl = null;
    _speakers = [];
    _listeners = [];
    _messages = [];
    _stageRequests = [];
    _stageCharacters.clear();
    _reactions.clear();
    _isMuted = false;
    _myRole = 'listener';
    _hasRaisedHand = false;
    _error = null;
    notifyListeners();

    loadRooms();
  }

  Future<bool> closeRoom() async {
    if (_activeRoom == null) return false;

    final roomId = _activeRoom!.id;

    try {
      final success = await _repository.closeRoom(roomId);
      if (success) {
        _cleanupLiveKit();
        _socket.leaveVoiceRoom(roomId);
        _cleanupSocketListeners();

        _activeRoom = null;
        _livekitToken = null;
        _livekitUrl = null;
        _speakers = [];
        _listeners = [];
        _messages = [];
        _stageRequests = [];
        _stageCharacters.clear();
        _reactions.clear();
        _myRole = 'listener';
        _hasRaisedHand = false;
        _error = null;
        notifyListeners();
        loadRooms();
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.e('closeRoom error', tag: 'VoiceRoomProvider', error: e);
      return false;
    }
  }

  // ==========================================================================
  // Mute
  // ==========================================================================

  Future<void> toggleMute() async {
    if (_activeRoom == null || !isSpeaker) return;

    try {
      final newMuteState = !_isMuted;
      if (_livekitRoom?.localParticipant != null) {
        await _livekitRoom!.localParticipant!
            .setMicrophoneEnabled(!newMuteState);
      }
      _isMuted = newMuteState;
      notifyListeners();

      _repository.toggleMute(_activeRoom!.id).catchError((e) {
        return null;
      });
    } catch (e) {
      AppLogger.e('toggleMute error', tag: 'VoiceRoomProvider', error: e);
    }
  }

  // ==========================================================================
  // Chat
  // ==========================================================================

  Future<void> sendMessage(String content) async {
    if (_activeRoom == null || content.trim().isEmpty) return;

    // Send via REST for persistence
    await _repository.sendMessage(_activeRoom!.id, content.trim());
  }

  Future<void> loadMessages({int? before}) async {
    if (_activeRoom == null) return;
    try {
      final msgs = await _repository.getMessages(
        _activeRoom!.id,
        before: before,
      );
      if (before != null) {
        _messages.insertAll(0, msgs);
      } else {
        _messages = msgs;
      }
      notifyListeners();
    } catch (e) {
      AppLogger.w('loadMessages error', tag: 'VoiceRoomProvider', error: e);
    }
  }

  // ==========================================================================
  // Stage Management
  // ==========================================================================

  Future<void> requestStage() async {
    if (_activeRoom == null || !isListener) return;
    // Optimistic: show raised hand immediately
    _hasRaisedHand = true;
    notifyListeners();
    try {
      final success = await _repository.requestStage(_activeRoom!.id);
      if (!success) {
        _hasRaisedHand = false;
        notifyListeners();
      }
    } catch (_) {
      _hasRaisedHand = false;
      notifyListeners();
    }
  }

  Future<void> cancelStageRequest() async {
    if (_activeRoom == null) return;
    // Optimistic: hide raised hand immediately
    _hasRaisedHand = false;
    notifyListeners();
    try {
      final success = await _repository.cancelStageRequest(_activeRoom!.id);
      if (!success) {
        _hasRaisedHand = true;
        notifyListeners();
      }
    } catch (_) {
      _hasRaisedHand = true;
      notifyListeners();
    }
  }

  Future<void> grantStage(int userId) async {
    if (_activeRoom == null || !isCreator) return;
    await _repository.grantStage(_activeRoom!.id, userId);
  }

  Future<void> removeFromStage(int userId) async {
    if (_activeRoom == null || !isCreator) return;
    await _repository.removeFromStage(_activeRoom!.id, userId);
  }

  Future<void> leaveStage() async {
    if (_activeRoom == null || !isSpeaker || isCreator) return;

    final result = await _repository.leaveStage(_activeRoom!.id);
    if (result.success) {
      _myRole = 'listener';
      if (result.livekitToken != null) {
        _livekitToken = result.livekitToken; // Save as fallback
      }
      _livekitUrl = result.livekitUrl ?? _livekitUrl;

      _stageCharacters.remove(_myUserId);

      // Server already revoked permissions via LiveKit API — no reconnect needed
      try {
        await _livekitRoom?.localParticipant?.setMicrophoneEnabled(false);
      } catch (_) {}
      _isMuted = false;
      notifyListeners();
    }
  }

  Future<bool> kickParticipant(int userId) async {
    if (_activeRoom == null || !isCreator) return false;
    try {
      return await _repository.kickParticipant(_activeRoom!.id, userId);
    } catch (e) {
      AppLogger.e('kickParticipant error', tag: 'VoiceRoomProvider', error: e);
      return false;
    }
  }

  Future<bool> inviteToStage(int userId) async {
    if (_activeRoom == null || !isCreator) return false;
    try {
      return await _repository.inviteToStage(_activeRoom!.id, userId);
    } catch (e) {
      AppLogger.e('inviteToStage error', tag: 'VoiceRoomProvider', error: e);
      return false;
    }
  }

  // ==========================================================================
  // Character Position (Stage Walking)
  // ==========================================================================

  void updateMyStagePosition(double x, double y, String direction) {
    if (!isSpeaker || _activeRoom == null) return;

    _myStageX = x;
    _myStageY = y;
    _myStageDirection = direction;

    // Update own character in stage map
    if (_myUserId != null && _stageCharacters.containsKey(_myUserId)) {
      _stageCharacters[_myUserId!]!.x = x;
      _stageCharacters[_myUserId!]!.y = y;
      _stageCharacters[_myUserId!]!.direction = direction;
      _stageCharacters[_myUserId!]!.targetX = x;
      _stageCharacters[_myUserId!]!.targetY = y;
    }

    // Throttle network sends to 10Hz with minimum delta
    final now = DateTime.now();
    if (_lastPositionSent != null &&
        now.difference(_lastPositionSent!) < _positionThrottle) {
      return;
    }

    _lastPositionSent = now;
    _socket.sendCharacterPosition(_activeRoom!.id, x, y, direction);
  }

  // ==========================================================================
  // Reactions & Gestures
  // ==========================================================================

  void sendReaction(String emoji) {
    if (_activeRoom == null) return;
    _socket.sendVoiceReaction(_activeRoom!.id, emoji);
  }

  bool canSendGesture() {
    if (_lastGestureSent == null) return true;
    return DateTime.now().difference(_lastGestureSent!) > _gestureCooldown;
  }

  void sendGesture(String gesture) {
    if (_activeRoom == null || !isSpeaker || !canSendGesture()) return;
    _lastGestureSent = DateTime.now();
    _socket.sendVoiceGesture(_activeRoom!.id, gesture);
  }

  // ==========================================================================
  // Refresh
  // ==========================================================================

  Future<void> refreshParticipants() async {
    if (_activeRoom == null) return;

    try {
      final result = await _repository.getRoom(_activeRoom!.id);
      if (result.room != null) {
        _activeRoom = result.room;
        _speakers = result.speakers;
        _listeners = result.listeners;
        _stageRequests = result.pendingRequests;

        // Update stage characters from fresh speaker data
        final currentCharIds = _stageCharacters.keys.toSet();
        final newSpeakerIds = _speakers.map((s) => s.userId).toSet();

        // Remove characters no longer on stage
        for (final id in currentCharIds.difference(newSpeakerIds)) {
          _stageCharacters.remove(id);
        }

        // Add/update characters
        for (final speaker in _speakers) {
          if (!_stageCharacters.containsKey(speaker.userId)) {
            _stageCharacters[speaker.userId] = StageCharacterState(
              userId: speaker.userId,
              name: speaker.name,
              avatar: speaker.avatar,
              equippedItems: speaker.equippedItems,
              skinColor: speaker.skinColor,
              isMuted: speaker.isMuted,
            );
          } else {
            _stageCharacters[speaker.userId]!.isMuted = speaker.isMuted;
          }
        }

        notifyListeners();
      }
    } catch (e) {
      AppLogger.w('refreshParticipants error',
          tag: 'VoiceRoomProvider', error: e);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Remove expired reactions (called from UI timer)
  void cleanupReactions() {
    final now = DateTime.now();
    _reactions.removeWhere(
        (r) => now.difference(r.createdAt).inMilliseconds > 2000);
  }

  @override
  void dispose() {
    _cleanupLiveKit();
    _cleanupSocketListeners();
    detachGameBridge();
    super.dispose();
  }
}
