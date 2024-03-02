import 'package:audio_book/core/error/failure.dart';
import 'package:audio_book/feature/domain/enitites/book_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<Failure, List<BookEntity>>> getBooks();
  Future<Either<Failure, String?>> downloadBook(String url);
}
