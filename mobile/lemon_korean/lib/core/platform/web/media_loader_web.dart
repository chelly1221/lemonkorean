import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../utils/app_logger.dart';
import '../media_loader_interface.dart';

/// Web implementation of IMediaLoader
/// Always streams media from remote server (no local caching)
class MediaLoaderImpl implements IMediaLoader {
  web.AudioElement? _audioElement;

  @override
  Future<String> getMediaPath(String remoteKey) async {
    // Web: Always return remote URL (no local files)
    return '${AppConstants.mediaUrl}/$remoteKey';
  }

  @override
  Widget loadImage(String url, {BoxFit fit = BoxFit.cover}) {
    // Web: Use Image.network (browser handles caching automatically)
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image);
      },
    );
  }

  @override
  Future<void> playAudio(String url) async {
    try {
      // Stop any currently playing audio
      await stopAudio();

      // Create new audio element
      _audioElement = web.HTMLAudioElement()
        ..src = url;
      _audioElement!.play();
    } catch (e) {
      AppLogger.e('Error playing audio', error: e, tag: 'MediaLoaderWeb');
      rethrow;
    }
  }

  @override
  Future<void> stopAudio() async {
    if (_audioElement != null) {
      _audioElement!.pause();
      _audioElement = null;
    }
  }

  @override
  Future<void> dispose() async {
    await stopAudio();
  }
}
