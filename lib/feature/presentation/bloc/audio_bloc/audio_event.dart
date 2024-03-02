part of 'audio_bloc.dart';

sealed class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class AudioLoadEvent extends AudioEvent {}

class AudioRepeatEvent extends AudioEvent {}

class AudioShuffleEvent extends AudioEvent {}

class AudioAddQueueItemsEvent extends AudioEvent {
  final List<BookEntity> books;

  const AudioAddQueueItemsEvent({required this.books});

  @override
  List<Object> get props => [books];
}

class AudioControlPlayEvent extends AudioEvent {
  final bool isPlaying;

  const AudioControlPlayEvent({required this.isPlaying});

  @override
  List<Object> get props => [isPlaying];
}
