import 'package:audio_book/core/audio/audio_handler.dart';
import 'package:audio_book/core/storage/book_storage.dart';
import 'package:audio_book/core/usecases/usecase.dart';
import 'package:audio_book/feature/data/models/book_model.dart';
import 'package:audio_book/feature/domain/enitites/book_entity.dart';
import 'package:audio_book/feature/domain/usecases/download_book.dart';
import 'package:audio_book/service_locator.dart' as di;
import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

part 'storage_state.dart';

class StorageCubit extends Cubit<StorageState> {
  final BookStorage storage;
  final DownloadBook downloadBook;
  StorageCubit(this.storage, this.downloadBook) : super(const StorageState());

  void getBooks() async {
    final audioHandler = di.sl<MyAudioHandler>();

    emit(state.copyWith(isLoading: true));
    final books = await storage.getBooks();

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
    for (var mediaItem in mediaItems) {
      final audioSource = _createAudioSource(mediaItem);
      if (!audioHandler.playlist.children.contains(audioSource)) {
        await audioHandler.addQueueItem(mediaItem);
      }
    }

    emit(state.copyWith(books: books, isLoading: false));
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['url'] as String),
      tag: mediaItem,
    );
  }

  void download(BookEntity book) async {
    final books = await storage.getBooks();

    final bookIndex = books.indexWhere((b) => b.id == book.id);

    if (bookIndex == -1) {
      final failureOrPath = await downloadBook.call(
        DownloadParams(url: book.url),
      );

      failureOrPath.fold(
        (error) => null,
        (path) async {
          final books = List.of(state.books);
          if (path != null) {
            var bookModel = BookModel(
              id: book.id,
              album: book.album,
              title: book.title,
              url: path,
              image: book.image,
              duration: book.duration,
            );
            await storage.save(bookModel);

            books.add(book);
            emit(state.copyWith(books: books));
          }
        },
      );
    }
  }
}
