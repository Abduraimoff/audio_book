import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/feature/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:audio_book/feature/presentation/screens/nav/bloc/navbar_bloc.dart';
import 'package:audio_book/feature/presentation/screens/nav/nav_screen.dart';
import 'package:audio_book/feature/presentation/theme/app_theme.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Initialize AudioService with MyAudioHandler as the audio handler
  final audioHandler = await AudioService.init(
    builder: () => di.sl<MyAudioHandler>(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.audiobook.example',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavBarBloc>(
          create: (context) => di.sl(),
        ),
        BlocProvider<AudioBloc>(
          lazy: false,
          create: (context) => di.sl()..add(AudioLoadEvent()),
        ),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: MaterialApp(
          title: 'Audio Book',
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          theme: AppTheme.theme(),
          home: const NavScreen(),
        ),
      ),
    );
  }
}
