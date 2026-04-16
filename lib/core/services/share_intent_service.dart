import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/logger.dart';

part 'share_intent_service.g.dart';

// ─── Payload types ─────────────────────────────────────────────────────────

sealed class SharedPayload {}

class SharedText extends SharedPayload {
  SharedText(this.value);
  final String value;
}

class SharedImages extends SharedPayload {
  SharedImages(this.bytes);
  final List<Uint8List> bytes;
}

// ─── Provider ──────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class ShareIntentNotifier extends _$ShareIntentNotifier {
  StreamSubscription<List<SharedMediaFile>>? _sub;

  @override
  SharedPayload? build() {
    _sub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (files) {
        if (files.isNotEmpty) _handleFiles(files);
      },
      onError: (e) => AppLogger.e('ShareIntent stream error: $e'),
    );

    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) _handleFiles(files);
    });

    ref.onDispose(() => _sub?.cancel());
    return null;
  }

  void consume() => state = null;

  Future<void> _handleFiles(List<SharedMediaFile> files) async {
    final first = files.first;

    if (first.type == SharedMediaType.url ||
        first.type == SharedMediaType.text) {
      state = SharedText(first.path);
      return;
    }

    if (first.type == SharedMediaType.image) {
      try {
        final bytesList = await Future.wait(
          files.take(5).map((f) => File(f.path).readAsBytes()),
        );
        state = SharedImages(bytesList);
      } catch (e) {
        AppLogger.e('ShareIntent: failed to read image bytes: $e');
      }
    }
  }
}
