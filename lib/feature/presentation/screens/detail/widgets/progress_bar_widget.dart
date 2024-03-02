import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/service_locator.dart' as di;
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final MediaItem item;
  const ProgressBarWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final audioHandler = di.sl<MyAudioHandler>();

    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, positionSnapshot) {
        if (positionSnapshot.data != null) {
          return ProgressBar(
            progress: positionSnapshot.data!,
            total: item.duration!,
            onSeek: (position) {
              audioHandler.seek(position);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
