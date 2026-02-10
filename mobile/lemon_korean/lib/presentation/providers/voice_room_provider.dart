import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../../core/services/socket_service.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/voice_room_model.dart';
import '../../data/repositories/voice_room_repository.dart';

/// Provider for voice room state management
class VoiceRoomProvider with ChangeNotifier {
  final VoiceRoomRepository _repository = VoiceRoomRepository();
  final SocketService _socket = SocketService.instance;

  List<VoiceRoomModel> _rooms = [];
  VoiceRoomModel? _activeRoom;
  List<VoiceParticipantModel> _participants = [];
  String? _livekitToken;
  String? _livekitUrl;
  bool _isLoading = false;
  bool _isMuted = false;
  String? _error;

  // LiveKit state
  lk.Room? _livekitRoom;
  lk.EventsListener<lk.RoomEvent>? _roomListener;
  bool _isConnecting = false;
  bool _isConnected = false;

  // Getters
  List<VoiceRoomModel> get rooms => _rooms;
  VoiceRoomModel? get activeRoom => _activeRoom;
  List<VoiceParticipantModel> get participants => _participants;
  String? get livekitToken => _livekitToken;
  String? get livekitUrl => _livekitUrl;
  bool get isLoading => _isLoading;
  bool get isMuted => _isMuted;
  String? get error => _error;
  bool get isInRoom => _activeRoom != null;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;

  /// Connect to LiveKit server using token and URL
  Future<void> _connectToLiveKit() async {
    if (_livekitToken == null || _livekitUrl == null) {
      AppLogger.e('Missing LiveKit token or URL', tag: 'VoiceRoomProvider');
      return;
    }

    // Skip LiveKit on web (not supported)
    if (kIsWeb) {
      AppLogger.w('LiveKit not supported on web', tag: 'VoiceRoomProvider');
      return;
    }

    _isConnecting = true;
    notifyListeners();

    try {
      // Create the room with audio-only defaults
      _livekitRoom = lk.Room(
        roomOptions: const lk.RoomOptions(
          defaultAudioPublishOptions: lk.AudioPublishOptions(
            dtx: true,
          ),
        ),
      );

      // Set up event listener
      _roomListener = _livekitRoom!.createListener();

      _roomListener!
        ..on<lk.RoomConnectedEvent>((_) {
          AppLogger.i('LiveKit connected', tag: 'VoiceRoomProvider');
          _isConnecting = false;
          _isConnected = true;
          notifyListeners();
        })
        ..on<lk.RoomDisconnectedEvent>((_) {
          AppLogger.i('LiveKit disconnected', tag: 'VoiceRoomProvider');
          _cleanupLiveKit();
        })
        ..on<lk.ParticipantConnectedEvent>((_) {
          refreshParticipants();
        })
        ..on<lk.ParticipantDisconnectedEvent>((_) {
          refreshParticipants();
        })
        ..on<lk.TrackMutedEvent>((_) {
          refreshParticipants();
        })
        ..on<lk.TrackUnmutedEvent>((_) {
          refreshParticipants();
        });

      // Connect to LiveKit
      await _livekitRoom!.connect(
        _livekitUrl!,
        _livekitToken!,
      );

      // Enable microphone after connecting
      await _livekitRoom!.localParticipant?.setMicrophoneEnabled(true);

      AppLogger.i('LiveKit microphone enabled', tag: 'VoiceRoomProvider');
    } catch (e) {
      AppLogger.e('LiveKit connection error', tag: 'VoiceRoomProvider', error: e);
      _isConnecting = false;
      _isConnected = false;
      notifyListeners();
    }
  }

  /// Clean up LiveKit resources
  void _cleanupLiveKit() {
    _roomListener?.dispose();
    _roomListener = null;

    _livekitRoom?.disconnect();
    _livekitRoom?.dispose();
    _livekitRoom = null;

    _isConnecting = false;
    _isConnected = false;
    notifyListeners();
  }

  /// Load active rooms
  Future<void> loadRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rooms = await _repository.getActiveRooms();
    } catch (e) {
      _error = 'Failed to load rooms';
      AppLogger.e('loadRooms error', tag: 'VoiceRoomProvider', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new voice room
  Future<bool> createRoom({
    required String title,
    String? topic,
    String languageLevel = 'all',
    int maxParticipants = 4,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.createRoom(
        title: title,
        topic: topic,
        languageLevel: languageLevel,
        maxParticipants: maxParticipants,
      );

      if (result.room != null) {
        _activeRoom = result.room;
        _livekitToken = result.livekitToken;
        _livekitUrl = result.livekitUrl;
        _isMuted = false;

        // Join socket room
        _socket.joinConversation(result.room!.id); // Reuse for voice room events
        _rooms.insert(0, result.room!);

        _isLoading = false;
        notifyListeners();

        // Connect to LiveKit after room created
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
      AppLogger.e('createRoom error', tag: 'VoiceRoomProvider', error: e);
      return false;
    }
  }

  /// Join an existing room
  Future<bool> joinRoom(int roomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.joinRoom(roomId);

      if (result.livekitToken != null) {
        _livekitToken = result.livekitToken;
        _livekitUrl = result.livekitUrl;
        _isMuted = false;

        // Get full room info
        final roomInfo = await _repository.getRoom(roomId);
        _activeRoom = roomInfo.room;
        _participants = roomInfo.participants;

        _isLoading = false;
        notifyListeners();

        // Connect to LiveKit after joining
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
      AppLogger.e('joinRoom error', tag: 'VoiceRoomProvider', error: e);
      return false;
    }
  }

  /// Leave the active room
  Future<void> leaveRoom() async {
    if (_activeRoom == null) return;

    // Disconnect LiveKit first
    _cleanupLiveKit();

    try {
      await _repository.leaveRoom(_activeRoom!.id);
    } catch (e) {
      AppLogger.e('leaveRoom error', tag: 'VoiceRoomProvider', error: e);
    }

    _activeRoom = null;
    _livekitToken = null;
    _livekitUrl = null;
    _participants = [];
    _isMuted = false;
    notifyListeners();

    // Refresh rooms list
    loadRooms();
  }

  /// Close the active room (creator only)
  Future<bool> closeRoom() async {
    if (_activeRoom == null) return false;

    try {
      final success = await _repository.closeRoom(_activeRoom!.id);
      if (success) {
        _cleanupLiveKit();

        _activeRoom = null;
        _livekitToken = null;
        _livekitUrl = null;
        _participants = [];
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

  /// Toggle mute
  Future<void> toggleMute() async {
    if (_activeRoom == null) return;

    try {
      // Toggle LiveKit local microphone first for instant feedback
      final newMuteState = !_isMuted;

      if (_livekitRoom?.localParticipant != null) {
        await _livekitRoom!.localParticipant!
            .setMicrophoneEnabled(!newMuteState);
      }

      _isMuted = newMuteState;
      notifyListeners();

      // Notify server asynchronously (fire-and-forget)
      _repository.toggleMute(_activeRoom!.id).catchError((e) {
        AppLogger.w('toggleMute server sync error',
            tag: 'VoiceRoomProvider', error: e);
        return null;
      });
    } catch (e) {
      AppLogger.e('toggleMute error', tag: 'VoiceRoomProvider', error: e);
    }
  }

  /// Refresh participants for active room
  Future<void> refreshParticipants() async {
    if (_activeRoom == null) return;

    try {
      final result = await _repository.getRoom(_activeRoom!.id);
      if (result.room != null) {
        _activeRoom = result.room;
        _participants = result.participants;
        notifyListeners();
      }
    } catch (e) {
      AppLogger.w('refreshParticipants error',
          tag: 'VoiceRoomProvider', error: e);
    }
  }

  @override
  void dispose() {
    _cleanupLiveKit();
    super.dispose();
  }
}
