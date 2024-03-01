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
  }

  Future<void> _loadEvent(
    AudioLoadEvent event,
    Emitter emit,
  ) async {
    final failureOrBooks = await getBooks.call(NoParams());
    failureOrBooks.fold((error) => null, (books) {
      final mediaItems = books
          .map((book) => MediaItem(
                id: book.id.toString(),
                album: book.album,
                title: book.title,
                extras: <String, dynamic>{'url': book.url},
              ))
          .toList();
      audioHandler.addQueueItems(mediaItems);

      emit(state.copyWith(books: books));
    });
  }
}
