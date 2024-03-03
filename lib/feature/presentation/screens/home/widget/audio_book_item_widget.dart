import 'package:audio_book/core/audio/audio_handler.dart';
import 'package:audio_book/feature/domain/enitites/book_entity.dart';
import 'package:audio_book/feature/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:audio_book/feature/presentation/bloc/storage_cubit/storage_cubit.dart';
import 'package:audio_book/service_locator.dart' as di;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudiBookItem extends StatelessWidget {
  final int orderNumber;
  final BookEntity book;
  final VoidCallback onTap;
  final MediaItem item;
  final int index;

  const AudiBookItem({
    super.key,
    required this.orderNumber,
    required this.onTap,
    required this.item,
    required this.index,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AudioBloc>().state;
    final audioHandler = di.sl<MyAudioHandler>();
    final theme = Theme.of(context);
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (BuildContext context, AsyncSnapshot<MediaItem?> snapshot) {
        if (snapshot.data != null) {
          bool isSelected = snapshot.data == item;
          return GestureDetector(
            onTap: () {
              if (snapshot.data! != item) {
                audioHandler.skipToQueueItem(index);
              }
              onTap();
            },
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
                      color: (state.isPlaying && isSelected)
                          ? Colors.amber[900]
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.title,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: (state.isPlaying && isSelected)
                          ? Colors.amber[900]
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      showPopupMenu(context, details.globalPosition, book);
                    },
                    child: Row(
                      children: [
                        if (state.isPlaying && isSelected) ...[
                          const ThreeDotAnimation(),
                          const SizedBox(width: 10),
                        ] else ...[
                          const Icon(
                            Icons.more_vert_outlined,
                            color: Colors.white,
                          )
                        ],
                      ],
                    ),
                  )
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

void showPopupMenu(BuildContext context, Offset tapPosition, BookEntity book) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect position =
      RelativeRect.fromSize(tapPosition & const Size(0, 0), overlay.size);

  showMenu(
    context: context,
    position: position,
    items: [
      const PopupMenuItem(
        value: 'download',
        child: Row(
          children: [
            Icon(Icons.download, color: Colors.black),
            SizedBox(width: 10),
            Text(
              'Download MP3',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    ],
  ).then((value) {
    if (value != null && value == 'download') {
      context.read<StorageCubit>().download(book);
    }
  });
}

class ThreeDotAnimation extends StatefulWidget {
  const ThreeDotAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
