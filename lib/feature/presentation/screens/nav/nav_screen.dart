import 'package:audio_book/feature/presentation/screens/home/home_screen.dart';
import 'package:audio_book/feature/presentation/screens/nav/bloc/navbar_bloc.dart';
import 'package:audio_book/feature/presentation/screens/saved/saved_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final _screens = [const HomeScreen(), const SavedScreen()];
  @override
  Widget build(BuildContext context) {
    final navBloc = context.read<NavBarBloc>();
    final navState = context.watch<NavBarBloc>().state;
    final activeIndex = navState.index;

    return Scaffold(
      body: _screens[activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIndex,
        onTap: (value) => navBloc.add(NavBarEvent(value)),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: ''),
        ],
      ),
    );
  }
}
