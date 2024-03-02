import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/feature/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:audio_book/service_locator.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerControlWidgets extends StatelessWidget {
  const PlayerControlWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AudioBloc>();
    final state = context.watch<AudioBloc>().state;
    final playing = state.isPlaying;
    final audioHandler = di.sl<MyAudioHandler>();
    if (playing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            IconButton(
              onPressed: () => bloc.add(AudioShuffleEvent()),
              icon: Icon(
                Icons.shuffle_rounded,
                color: state.isShuffleModeEnabled
                    ? Colors.amber[900]
                    : Colors.white,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => audioHandler.skipToPrevious(),
              icon: const Icon(Icons.skip_previous_rounded),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                if (playing) {
                  audioHandler.pause();
                } else {
                  audioHandler.play();
                }
              },
              icon: Icon(
                playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
              ),
              iconSize: 50,
              color: Colors.amber[900],
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () => audioHandler.skipToNext(),
              icon: const Icon(Icons.skip_next_rounded),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => bloc.add(AudioRepeatEvent()),
              icon: Icon(
                Icons.repeat_rounded,
                color: state.repeatState == RepeatState.repeatSong
                    ? Colors.amber[900]
                    : Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
