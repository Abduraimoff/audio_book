// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/feature/presentation/screens/detail/widgets/control_widgets.dart';
import 'package:audio_book/feature/presentation/screens/detail/widgets/progress_bar_widget.dart';
import 'package:audio_book/service_locator.dart' as di;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioHandler = di.sl<MyAudioHandler>();
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, mediaSnapshot) {
            if (mediaSnapshot.data != null) {
              MediaItem item = mediaSnapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber[900]!,
                          Colors.yellow,
                        ],
                      ),
                      image: DecorationImage(
                        image: NetworkImage(item.artUri.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    item.title,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    item.album ?? '',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 100),
                  ProgressBarWidget(item: item),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: const PlayerControlWidgets(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
