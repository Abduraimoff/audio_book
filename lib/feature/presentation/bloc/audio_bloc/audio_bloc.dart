import 'package:audio_book/core/audio/audio_service.dart';
import 'package:audio_book/core/usecases/usecase.dart';
import 'package:audio_book/feature/domain/enitites/book_entity.dart';
import 'package:audio_book/feature/domain/usecases/get_books.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final GetBooks getBooks;
  final MyAudioHandler audioHandler;
  AudioBloc(this.getBooks, this.audioHandler) : super(const AudioState()) {
    on<AudioLoadEvent>(_loadEvent);
    on<AudioRepeatEvent>(_repeatEvent);
    on<AudioShuffleEvent>(_shuffleEvent);
    on<AudioAddQueueItemsEvent>(_addQueueItemsEvent);
    on<AudioControlPlayEvent>(_controlPlayEvent);
    audioHandler.playbackState.stream.listen(_handlePlaybackState);
  }
  Future<void> _loadEvent(
    AudioLoadEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final failureOrBooks = await getBooks.call(NoParams());
    await failureOrBooks.fold(
      (error) async {
        emit(state.copyWith(error: 'No data', isLoading: false));
      },
      (books) async {
        final mediaItems = books.map((book) {
          double secondsDouble = double.parse(book.duration);
          int seconds = secondsDouble.toInt();
          Duration duration = Duration(seconds: seconds);
          return MediaItem(
            id: book.id.toString(),
            album: book.album,
            title: book.title,
            duration: duration,
            extras: <String, dynamic>{'url': book.url},
            artUri: Uri.parse(book.image),
          );
        }).toList();
        await audioHandler.addQueueItems(mediaItems);

        emit(state.copyWith(books: books, isLoading: false));
      },
    );
  }

  Future<void> _addQueueItemsEvent(
    AudioAddQueueItemsEvent event,
    Emitter emit,
  ) async {
    final mediaItems = event.books.map((book) {
      double secondsDouble = double.parse(book.duration);
      int seconds = secondsDouble.toInt();
      Duration duration = Duration(seconds: seconds);
      return MediaItem(
        id: book.id.toString(),
        album: book.album,
        title: book.title,
        duration: duration,
        extras: <String, dynamic>{'url': book.url},
        artUri: Uri.parse(book.image),
      );
    }).toList();
    await audioHandler.addQueueItems(mediaItems);
  }

  Future<void> _repeatEvent(
    AudioRepeatEvent event,
    Emitter emit,
  ) async {
    final repeatMode = state.repeatState;
    if (repeatMode == RepeatState.off) {
      audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
      emit(state.copyWith(repeatState: RepeatState.repeatSong));
    } else {
      audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
      emit(state.copyWith(repeatState: RepeatState.off));
    }
  }

  Future<void> _shuffleEvent(
    AudioShuffleEvent event,
    Emitter emit,
  ) async {
    if (state.isShuffleModeEnabled) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
      emit(state.copyWith(isShuffleModeEnabled: false));
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
      emit(state.copyWith(isShuffleModeEnabled: true));
    }
  }

  Future<void> _controlPlayEvent(
    AudioControlPlayEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(isPlaying: event.isPlaying));
  }

  void _handlePlaybackState(PlaybackState playbackState) {
    bool isPlaying = playbackState.playing;

    add(AudioControlPlayEvent(isPlaying: isPlaying));
  }
}
