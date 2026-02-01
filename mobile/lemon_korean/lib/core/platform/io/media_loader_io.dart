import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../storage/database_helper.dart';
import '../media_loader_interface.dart';

/// Mobile implementation of IMediaLoader
/// Loads from local files if available, otherwise from remote server
class MediaLoaderImpl implements IMediaLoader {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<String> getMediaPath(String remoteKey) async {
    try {
      // Try to get local path from database
      // getLocalPath already updates last_accessed internally
      final localPath = await DatabaseHelper.instance.getLocalPath(remoteKey);

      if (localPath != null) {
        final file = File(localPath);
        if (await file.exists()) {
          return localPath;
        }
      }
    } catch (e) {
      // If database query fails, fall back to remote
      print('[MediaLoaderIO] Error getting local path: $e');
    }

    // Return remote URL if local file not found
    return '${AppConstants.mediaUrl}/$remoteKey';
  }

  @override
  Widget loadImage(String url, {BoxFit fit = BoxFit.cover}) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      // Remote image
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      // Local file
      return Image.file(
        File(url),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image);
        },
      );
    }
  }

  @override
  Future<void> playAudio(String url) async {
    try {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        // Remote URL
        await _audioPlayer.play(UrlSource(url));
      } else {
        // Local file
        await _audioPlayer.play(DeviceFileSource(url));
      }
    } catch (e) {
      print('[MediaLoaderIO] Error playing audio: $e');
      rethrow;
    }
  }

  @override
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  @override
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
