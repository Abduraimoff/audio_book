// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'audio_bloc.dart';

enum RepeatState { off, repeatSong }

class AudioState extends Equatable {
  final bool isLoading;
  final bool isPlaying;
  final RepeatState repeatState;
  final String currentSongTitle;
  final String? error;
  final bool isShuffleModeEnabled;
  final List<BookEntity> books;

  const AudioState({
    this.isLoading = false,
    this.isPlaying = false,
    this.repeatState = RepeatState.off,
    this.currentSongTitle = '',
    this.error,
    this.isShuffleModeEnabled = false,
    this.books = const [],
  });

  AudioState copyWith({
    bool? isLoading,
    bool? isPlaying,
    RepeatState? repeatState,
    String? currentSongTitle,
    bool? isShuffleModeEnabled,
    List<BookEntity>? books,
    String? error,
  }) {
    return AudioState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isPlaying: isPlaying ?? this.isPlaying,
      repeatState: repeatState ?? this.repeatState,
      currentSongTitle: currentSongTitle ?? this.currentSongTitle,
      isShuffleModeEnabled: isShuffleModeEnabled ?? this.isShuffleModeEnabled,
      books: books ?? this.books,
    );
  }

  @override
  List<Object?> get props {
    return [
      isPlaying,
      error,
      isLoading,
      repeatState,
      currentSongTitle,
      isShuffleModeEnabled,
      books,
    ];
  }
}
