import 'dart:async';

import '../../data/models/character_item_model.dart';

// ============================================================================
// Events: Flutter → FLAME
// ============================================================================

/// Base class for events sent from Flutter Providers to the FLAME game.
sealed class GameEvent {}

/// Character equipment changed (re-render layers).
class CharacterEquipmentChanged extends GameEvent {
  final List<CharacterItemModel> equippedItems;
  final String skinColor;
  CharacterEquipmentChanged({required this.equippedItems, required this.skinColor});
}

/// Remote character moved (voice stage).
class RemoteCharacterMoved extends GameEvent {
  final int userId;
  final double x;
  final double y;
  final String direction;
  RemoteCharacterMoved({
    required this.userId,
    required this.x,
    required this.y,
    required this.direction,
  });
}

/// Remote character performed a gesture.
class RemoteGestureReceived extends GameEvent {
  final int userId;
  final String gesture;
  RemoteGestureReceived({required this.userId, required this.gesture});
}

/// Emoji reaction received.
class ReactionReceived extends GameEvent {
  final String emoji;
  final int userId;
  final double startX;
  final double startY;
  ReactionReceived({
    required this.emoji,
    required this.userId,
    required this.startX,
    required this.startY,
  });
}

/// Mute state changed for a speaker.
class MuteStateChanged extends GameEvent {
  final int userId;
  final bool isMuted;
  MuteStateChanged({required this.userId, required this.isMuted});
}

/// A visitor joined the room.
class VisitorJoined extends GameEvent {
  final int userId;
  final String name;
  final List<CharacterItemModel> equippedItems;
  final String skinColor;
  VisitorJoined({
    required this.userId,
    required this.name,
    required this.equippedItems,
    required this.skinColor,
  });
}

/// A visitor left the room.
class VisitorLeft extends GameEvent {
  final int userId;
  VisitorLeft({required this.userId});
}

/// Remote character added to stage (voice room).
class RemoteCharacterAdded extends GameEvent {
  final int userId;
  final String name;
  final Map<String, dynamic>? equippedItems;
  final String? skinColor;
  final bool isMuted;
  RemoteCharacterAdded({
    required this.userId,
    required this.name,
    this.equippedItems,
    this.skinColor,
    this.isMuted = false,
  });
}

/// Remote character removed from stage.
class RemoteCharacterRemoved extends GameEvent {
  final int userId;
  RemoteCharacterRemoved({required this.userId});
}

// ============================================================================
// Events: FLAME → Flutter
// ============================================================================

/// Base class for events sent from FLAME game back to Flutter.
sealed class FlutterEvent {}

/// Local player moved (for Socket.IO broadcast).
class LocalCharacterMoved extends FlutterEvent {
  final double x;
  final double y;
  final String direction;
  LocalCharacterMoved({required this.x, required this.y, required this.direction});
}

/// Furniture tapped in MyRoom.
class FurnitureTapped extends FlutterEvent {
  final int furnitureId;
  final String? action;
  FurnitureTapped({required this.furnitureId, this.action});
}

/// Mini-game requested from furniture interaction.
class MiniGameRequested extends FlutterEvent {
  final String gameType;
  MiniGameRequested({required this.gameType});
}

// ============================================================================
// Bridge
// ============================================================================

/// Bidirectional event bridge between Flutter Provider layer and FLAME game.
///
/// Providers push [GameEvent]s for the game to consume.
/// The game pushes [FlutterEvent]s for providers/screens to consume.
class GameBridge {
  final _gameEventController = StreamController<GameEvent>.broadcast();
  final _flutterEventController = StreamController<FlutterEvent>.broadcast();

  /// Stream of events for the FLAME game to listen to.
  Stream<GameEvent> get gameEvents => _gameEventController.stream;

  /// Stream of events for Flutter widgets/providers to listen to.
  Stream<FlutterEvent> get flutterEvents => _flutterEventController.stream;

  /// Send an event to the FLAME game.
  void sendToGame(GameEvent event) {
    if (!_gameEventController.isClosed) {
      _gameEventController.add(event);
    }
  }

  /// Send an event from FLAME to Flutter.
  void sendToFlutter(FlutterEvent event) {
    if (!_flutterEventController.isClosed) {
      _flutterEventController.add(event);
    }
  }

  void dispose() {
    _gameEventController.close();
    _flutterEventController.close();
  }
}
