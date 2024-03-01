// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'audio_bloc.dart';

enum ButtonState {
  paused,
  playing,
  loading,
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}

class AudioState extends Equatable {
  final ButtonState playButton;
  final ProgressBarState progressBar;
  final RepeatState repeatState;
  final String currentSongTitle;
  final List playlist;
  final bool isFirstSong;
  final bool isLastSong;
  final bool isShuffleModeEnabled;
  final List<BookEntity> books;

  const AudioState({
    this.playButton = ButtonState.paused,
    this.progressBar = const ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
    this.repeatState = RepeatState.off,
    this.currentSongTitle = '',
    this.playlist = const [],
    this.isFirstSong = true,
    this.isLastSong = false,
    this.isShuffleModeEnabled = false,
    this.books = const [],
  });

  AudioState copyWith({
    ButtonState? playButton,
    ProgressBarState? progressBar,
    RepeatState? repeatState,
    String? currentSongTitle,
    List? playlist,
    bool? isFirstSong,
    bool? isLastSong,
    bool? isShuffleModeEnabled,
    List<BookEntity>? books,
  }) {
    return AudioState(
      playButton: playButton ?? this.playButton,
      progressBar: progressBar ?? this.progressBar,
      repeatState: repeatState ?? this.repeatState,
      currentSongTitle: currentSongTitle ?? this.currentSongTitle,
      playlist: playlist ?? this.playlist,
      isFirstSong: isFirstSong ?? this.isFirstSong,
      isLastSong: isLastSong ?? this.isLastSong,
      isShuffleModeEnabled: isShuffleModeEnabled ?? this.isShuffleModeEnabled,
      books: books ?? this.books,
    );
  }

  @override
  List<Object> get props {
    return [
      playButton,
      progressBar,
      repeatState,
      currentSongTitle,
      playlist,
      isFirstSong,
      isLastSong,
      isShuffleModeEnabled,
      books,
    ];
  }
}
