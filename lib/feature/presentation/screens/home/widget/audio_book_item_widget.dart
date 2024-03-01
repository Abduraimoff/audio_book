import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/service_locator.dart' as di;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class AudiBookItem extends StatelessWidget {
  final bool isPlaying;
  final int orderNumber;
  final VoidCallback onTap;
  // MediaItem representing the current song
  final MediaItem item;
  // Index of the song in the list
  final int index;

  const AudiBookItem({
    super.key,
    this.isPlaying = false,
    required this.orderNumber,
    required this.onTap,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final audioHandler = di.sl<MyAudioHandler>();
    final theme = Theme.of(context);
    final color = isPlaying ? Colors.amber[900] : Colors.white;
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (BuildContext context, AsyncSnapshot<MediaItem?> snapshot) {
        if (snapshot.data != null) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$orderNumber',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Self Care',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  isPlaying
                      ? const Row(
                          children: [
                            ThreeDotAnimation(),
                            SizedBox(width: 10),
                          ],
                        )
                      : Icon(Icons.more_vert_outlined, color: color)
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ThreeDotAnimation extends StatefulWidget {
  const ThreeDotAnimation({super.key});

  @override
  _ThreeDotAnimationState createState() => _ThreeDotAnimationState();
}

class _ThreeDotAnimationState extends State<ThreeDotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Dot(
          controller: _controller,
          offset: const Duration(milliseconds: 0),
        ),
        const SizedBox(height: 2),
        Dot(
          controller: _controller,
          offset: const Duration(milliseconds: 250),
        ),
        const SizedBox(height: 2),
        Dot(
          controller: _controller,
          offset: const Duration(milliseconds: 500),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final AnimationController controller;
  final Duration offset;

  const Dot({super.key, required this.controller, required this.offset});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            offset.inMilliseconds / 1000,
            (offset.inMilliseconds + 500) / 1000,
            curve: Curves.easeInOut,
          ),
        ),
      ),
      child: Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.amber[900],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
