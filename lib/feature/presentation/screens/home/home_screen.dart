import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/feature/presentation/screens/home/bloc/audio_bloc/audio_bloc.dart';
import 'package:audio_book/feature/presentation/screens/home/widget/audio_book_item_widget.dart';
import 'package:audio_book/service_locator.dart' as di;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final audioHandler = di.sl<MyAudioHandler>();
    final state = context.watch<AudioBloc>().state;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Audio Book list',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 40),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print(state.books.length);
                  final mediaItems = state.books
                      .map((book) => MediaItem(
                            id: book.id.toString(),
                            album: book.album,
                            title: book.title,
                            extras: {'url': book.url},
                          ))
                      .toList();
                  return AudiBookItem(
                    onTap: () {
                      audioHandler.play();
                      // setState(() {
                      //   _selectedIndex = index;
                      // });

                      // var materialPageRoute = MaterialPageRoute(
                      //   builder: (context) => const DetailScreen(),
                      // );
                      // Navigator.push(context, materialPageRoute);
                    },
                    orderNumber: index + 1,
                    isPlaying: _selectedIndex == index,
                    item: mediaItems[index],
                    index: index,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 35);
                },
                itemCount: state.books.length,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}